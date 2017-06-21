ENV['sg']                 ||= 'private_sg'
ENV['chef_run_list']      ||= 'role[mzconvert]'
ENV['lb_name']            ||= "#{ENV['org']}-#{ENV['environment']}-mzconvert-elb"
ENV['notification_topic'] ||= "#{ENV['org']}_#{ENV['environment']}_deregister_chef_node"

SparkleFormation.new('couchbase').load(:base, :chef_base, :win2016_ami, :ssh_key_pair, :git_rev_outputs).overrides do
  description <<"EOF"
MZConvert EC2 instances, configured by Chef. ELB. Route53 record: mzconvert.#{ENV['private_domain']}.
EOF

  dynamic!(:iam_instance_profile, 'mzconvert',
           :chef_bucket => registry!(:my_s3_bucket, 'chef')
          )

  dynamic!(:elb, 'mzconvert',
           :listeners => [
             { :instance_port => '80', :instance_protocol => 'tcp', :load_balancer_port => '80', :protocol => 'tcp'}
           ],
           :policies => [ ],
           :security_groups => _array( registry!(:my_security_group_id) ),
           :idle_timeout => '600',
           :subnets => registry!(:my_private_subnet_ids),
           :scheme => 'internal',
           :lb_name => ENV['lb_name']
  )

  dynamic!(:launch_config, 'mzconvert',
           :iam_instance_profile => 'MzconvertIAMInstanceProfile',
           :iam_role => 'MzconvertIAMRole',
           :create_ebs_volumes => false,
           :volume_count => ENV['volume_count'].to_i,
           :volume_size => ENV['volume_size'].to_i,
           :security_groups => _array( registry!(:my_security_group_id) ),
           :chef_run_list => ENV['chef_run_list']
          )

  dynamic!(:auto_scaling_group, 'mzconvert',
           :launch_config => :mzconvert_auto_scaling_launch_configuration,
           :subnet_ids => registry!(:my_private_subnet_ids),
           :load_balancers => _array(ref!(:mzconvert_elastic_load_balancing_load_balancer)),
           :notification_topic => registry!(:my_sns_topics, ENV['notification_topic'])
          )

  dynamic!(:record_set, 'mzconvert',
           :record => 'mzconvert',
           :target => :mzconvert_elastic_load_balancing_load_balancer,
           :domain_name => ENV['private_domain'],
           :attr => 'DNSName',
           :ttl => '60'
  )
end
