class InterFAX::Outbound

  attr_writer :delivery

  def initialize client
    @client = client
  end

  def delivery
    @delivery ||= InterFAX::Outbound::Delivery.new(@client)
  end

  def deliver params = {}
    delivery.deliver(params)
  end

  def all params = {}
    valid_keys = [:limit, :lastId, :sortOrder, :userId]
    @client.get('/outbound/faxes', params, valid_keys).map do |fax|
      fax[:client] = @client
      InterFAX::Outbound::Fax.new(fax)
    end
  end

  def completed *ids
    params = { ids: [ids].flatten }
    valid_keys = [:ids]
    @client.get('/outbound/faxes/completed', params, valid_keys).map do |fax|
      fax[:client] = @client
      InterFAX::Outbound::Fax.new(fax)
    end
  end

  def find id
    fax = @client.get("/outbound/faxes/#{id}")
    fax[:client] = @client
    InterFAX::Outbound::Fax.new(fax)
  end

  def image fax_id
    data = @client.get("/outbound/faxes/#{fax_id}/image")
    InterFAX::Image.new(data: data, client: @client)
  end

  def cancel fax_id
    fax = @client.get("/outbound/faxes/#{fax_id}/cancel")
    fax[:client] = @client
    InterFAX::Outbound::Fax.new(fax)
  end

  def search params = {}
    valid_keys = [:ids, :reference, :dateFrom, :dateTo, :status, :userId, :faxNumber, :limit, :offset]
    @client.get('/outbound/search', params, valid_keys).map do |fax|
      fax[:client] = @client
      InterFAX::Outbound::Fax.new(fax)
    end
  end
end