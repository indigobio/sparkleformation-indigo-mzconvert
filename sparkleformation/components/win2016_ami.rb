SparkleFormation.component(:win2016_ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-b34b65a5')
    set!('us-east-2'.disable_camel!, :ami => 'ami-0d9cba68')
    set!('us-west-1'.disable_camel!, :ami => 'ami-bac0edda')
    set!('us-west-2'.disable_camel!, :ami => 'ami-f71b0e8e')
  end
end
