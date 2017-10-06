SparkleFormation.new('mzconvert').load(:base, :chef_base, :win2k8_ami, :ssh_key_pair, :git_rev_outputs).overrides do
  description <<"EOF"
MZConvert EC2 instances, configured by Chef. ELB. Route53 record: mzconvert.#{ENV['private_domain']}.
EOF

  ENV['sg']                 ||= 'private_sg'
  ENV['chef_run_list']      ||= 'recipe[ascent_monitoring::mzconvert]'
  ENV['lb_name']            ||= "#{ENV['org']}-#{ENV['environment']}-mzconvert-elb"

  dynamic!(:iam_instance_profile, 'mzconvert',
           :chef_bucket => registry!(:my_s3_bucket, 'chef')
          )

  dynamic!(:iam_instance_profile, 'slowconvert',
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

  dynamic!(:elb, 'slowconvert',
           :listeners => [
             { :instance_port => '80', :instance_protocol => 'tcp', :load_balancer_port => '80', :protocol => 'tcp'}
           ],
           :policies => [ ],
           :security_groups => _array( registry!(:my_security_group_id) ),
           :idle_timeout => '600',
           :subnets => registry!(:my_private_subnet_ids),
           :scheme => 'internal',
           :lb_name => "#{ENV['org']}-#{ENV['environment']}-slowconvert-elb"
  )

  dynamic!(:launch_config, 'mzconvert',
           :iam_instance_profile => 'MzconvertIAMInstanceProfile',
           :iam_role => 'MzconvertIAMRole',
           :create_ebs_volumes => false,
           :volume_count => ENV['volume_count'].to_i,
           :volume_size => ENV['volume_size'].to_i,
           :security_groups => _array( registry!(:my_security_group_id) ),
           :chef_run_list => ENV['chef_run_list'],
           :chef_attributes => {
             'datadog' => {
               'api_key' => ENV['dd_api_key'],
               'app_key' => ENV['dd_app_key'],
               'collect_ec2_tags' => 'yes',
               'dogstatsd' => false,
               'use_ec2_instance_id' => false,
               'agent_version' => {
                 'windows' => ENV['dd_agent_version']
               }
             }
           }
          )

  dynamic!(:launch_config, 'slowconvert',
           :iam_instance_profile => 'SlowconvertIAMInstanceProfile',
           :iam_role => 'SlowconvertIAMRole',
           :create_ebs_volumes => false,
           :volume_count => ENV['volume_count'].to_i,
           :volume_size => ENV['volume_size'].to_i,
           :security_groups => _array( registry!(:my_security_group_id) ),
           :chef_run_list => ENV['chef_run_list'],
           :chef_attributes => {
             'datadog' => {
               'api_key' => ENV['dd_api_key'],
               'app_key' => ENV['dd_app_key'],
               'collect_ec2_tags' => 'yes',
               'dogstatsd' => false,
               'use_ec2_instance_id' => false,
               'agent_version' => {
                 'windows' => ENV['dd_agent_version']
               }
             }
           }
          )

  dynamic!(:auto_scaling_group, 'mzconvert',
           :launch_config => :mzconvert_auto_scaling_launch_configuration,
           :subnet_ids => registry!(:my_private_subnet_ids),
           :load_balancers => _array(ref!(:mzconvert_elastic_load_balancing_load_balancer))
          )

  dynamic!(:auto_scaling_group, 'slowconvert',
           :launch_config => :slowconvert_auto_scaling_launch_configuration,
           :subnet_ids => registry!(:my_private_subnet_ids),
           :load_balancers => _array(ref!(:slowconvert_elastic_load_balancing_load_balancer))
          )

  dynamic!(:record_set, 'mzconvert',
           :record => 'mzconvert',
           :target => :mzconvert_elastic_load_balancing_load_balancer,
           :domain_name => ENV['private_domain'],
           :attr => 'DNSName',
           :ttl => '60'
  )

  dynamic!(:record_set, 'slowconvert',
           :record => 'slowconvert',
           :target => :slowconvert_elastic_load_balancing_load_balancer,
           :domain_name => ENV['private_domain'],
           :attr => 'DNSName',
           :ttl => '60'
  )
end
