SparkleFormation.component(:win2k8_ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-d86797a2')
    set!('us-east-2'.disable_camel!, :ami => 'ami-335a7756')
    set!('us-west-1'.disable_camel!, :ami => 'ami-40625220')
    set!('us-west-2'.disable_camel!, :ami => 'ami-d9ef16a1')
  end
end
