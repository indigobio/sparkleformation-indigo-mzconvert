SparkleFormation.component(:win2016_ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-56a8452c')
    set!('us-east-2'.disable_camel!, :ami => 'ami-1dd6f478')
    set!('us-west-1'.disable_camel!, :ami => 'ami-6ec3f50e')
    set!('us-west-2'.disable_camel!, :ami => 'ami-30619348')
  end
end
