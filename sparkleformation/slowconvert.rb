ENV['sg']                 ||= 'private_sg'
ENV['chef_run_list']      ||= 'recipe[ascent_monitoring::mzconvert]'
ENV['lb_name']            ||= "#{ENV['org']}-#{ENV['environment']}-slowconvert-elb"

SparkleFormation.new('slowconvert').load(:base, :win2016_ami, :ssh_key_pair, :git_rev_outputs).overrides do
  description <<"EOF"
MZConvert EC2 instances, configured by Chef. ELB. Route53 record: slowconvert.#{ENV['private_domain']}.
EOF

  dynamic!(:iam_instance_profile, 'slowconvert',
           :chef_bucket => registry!(:my_s3_bucket, 'chef')
          )

  dynamic!(:elb, 'slowconvert',
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

  dynamic!(:launch_config, 'slowconvert',
           :iam_instance_profile => 'SlowconvertIAMInstanceProfile',
           :iam_role => 'SlowconvertIAMRole',
           :create_ebs_volumes => false,
           :volume_count => ENV['volume_count'].to_i,
           :volume_size => ENV['volume_size'].to_i,
           :security_groups => _array( registry!(:my_security_group_id) ),
           :chef_run_list => ENV['chef_run_list']
          )

  dynamic!(:auto_scaling_group, 'slowconvert',
           :launch_config => :slowconvert_auto_scaling_launch_configuration,
           :subnet_ids => registry!(:my_private_subnet_ids),
           :load_balancers => _array(ref!(:slowconvert_elastic_load_balancing_load_balancer))
          )

  dynamic!(:record_set, 'slowconvert',
           :record => 'slowconvert',
           :target => :slowconvert_elastic_load_balancing_load_balancer,
           :domain_name => ENV['private_domain'],
           :attr => 'DNSName',
           :ttl => '60'
  )
end
