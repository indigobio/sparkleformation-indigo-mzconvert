SparkleFormation.component(:win2016_ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-86ab9a90')
    set!('us-east-2'.disable_camel!, :ami => 'ami-c65b7aa3')
    set!('us-west-1'.disable_camel!, :ami => 'ami-d5e9c5b5')
    set!('us-west-2'.disable_camel!, :ami => 'ami-d44355ad')
  end
end
