SparkleFormation.component(:win2k8_ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-8c7b2a9b')
    set!('us-east-2'.disable_camel!, :ami => 'ami-863f1de3')
    set!('us-west-1'.disable_camel!, :ami => 'ami-acd890cc')
    set!('us-west-2'.disable_camel!, :ami => 'ami-d49035b4')
  end
end
