# added flow specific methods to Spree::Variant

Spree::Product.class_eval do

  # returns price tied to local experience from master variant
  def flow_local_price(flow_exp)
    variants.first.flow_local_price(flow_exp)
  end

end
