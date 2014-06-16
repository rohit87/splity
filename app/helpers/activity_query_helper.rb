module ActivityQueryHelper

  def get_activities_query_from_params
    query = { }
    poorly_written_query = {}
    
    if params[:query]
      for key in params[:query].keys
        case key
        when "date"
          query[key] = Date.parse(params[:query][key])
        when "friend"
          poorly_written_query = {
            participations: {
              activity_id: User.find(params[:query][:friend]).activities.pluck(:id)
            }
          }
        else
          query[key] = params[:query][key]
        end
      end
    end
    query.merge! poorly_written_query
  end

end