# added flow specific methods to Spree::Variant
# solidus / spree save all the prices inside Variant object
# we choose to have cache jsonb field named flow_cache that will hold all important
# flow sync data for specific

Spree::Variant.class_eval do

  # clears flow cache from all records
  def self.flow_truncate
    all_records = all
    all_records.each { |o| o.update_column :flow_cache, {} }
    puts 'Truncated %d records' % all_records.length
  end

  def flow_spree_price
    '%s %s' % [self.price, self.cost_currency]
  end

  def flow_prices(flow_exp)
    if cache = flow_cache['exp']
      if data = cache[flow_exp.key]
        return data['prices'] || []
      end
    end
    []
  end

  # returns price tied to local experience
  def flow_local_price(flow_exp)
    # TODO: Show all prices, not just first
    if price = flow_prices(flow_exp).first
      price['label']
    else
      flow_spree_price
    end
  end

  # creates object for flow api
  # TODO: Remove and use the one in rakefile
  def flow_api_item
    image_base = 'http://cdn.color-mont.com'

    Io::Flow::V0::Models::ItemForm.new(
      number:      id.to_s,
      locale:      'en_US',
      language:    'en',
      name:        product.name,
      description: product.description,
      currency:    cost_currency,
      price:       price.to_f,
      images: [
        { url: image_base + product.display_image.attachment(:large), tags: ['main'] },
        { url: image_base + product.images.first.attachment.url(:product), tags: ['thumbnail'] }
      ],
      attributes: {
        weight: weight.to_s,
        height: height.to_s,
        width: width.to_s,
        depth: depth.to_s,
        is_master: is_master ? 'true' : 'false',
        product_id: product_id.to_s,
        tax_category: product.tax_category_id.to_s,
        product_description: product.description,
        product_shipping_category: product.shipping_category_id ? shipping_category.name : nil,
        product_meta_title: product.meta_title.to_s,
        product_meta_description: product.meta_description.to_s,
        product_meta_keywords: product.meta_keywords.to_s,
        product_slug: product.slug,
      }.select{ |k,v| v.present? }
    )
  end

  # gets flow catalog item, and imports it
  # it is intentionally here
  def flow_import_item(item)
    experience_key = item.local.experience.key
    flow_cache['exp'] ||= {}
    flow_cache['exp'][experience_key] = {}
    flow_cache['exp'][experience_key]['prices'] = item.local.prices.map do |price|
      price = price.to_hash
      [:includes, :adjustment].each { |el| price.delete(el) unless price[el] }
      price
    end

    update_column :flow_cache, flow_cache.dup
  end

  def flow_do_sync?(after_upload=false)
    @item_sh1 ||= Digest::SHA1.hexdigest flow_api_item.to_json

    flow_cache ||= {}

    if after_upload
      variant.update_column :flow_hash, flow_cache.merge('last_sync_sh1'=>@item_sh1)
    else
      flow_cache['last_sync_sh1'] != @item_sh1
    end
  end

end

