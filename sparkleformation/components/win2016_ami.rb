SparkleFormation.component(:win2016_ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-9e84b6e5')
    set!('us-east-2'.disable_camel!, :ami => 'ami-b76d4ed2')
    set!('us-west-1'.disable_camel!, :ami => 'ami-4d163c2d')
    set!('us-west-2'.disable_camel!, :ami => 'ami-ed09e495')
  end
end
