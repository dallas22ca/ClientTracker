class Importer

  def initialize(user_id)
    @user_id = user_id
  end
  
  def user
    @user ||= User.find @user_id
  end
  
  def spreadsheet
    @spreadsheet ||= open_spreadsheet
  end
  
  def import
    row_count = spreadsheet.count
  
    (2..spreadsheet.last_row).each do |i|
      data = Hash[[headers, spreadsheet.row(i).map{ |c| c.to_s.strip }].transpose]
      key = data.delete("key")
      key = data["email"] unless key
      key = data["name"] unless key
      data["email"] = data.delete("email-address") unless data["email"]
      
      contact = Contact.create(
        user_id: user.id,
        key: key,
        data: data
      )
    end
      
    delete_file
    
    { success: true }
  end
  
  def delete_file
    user.file = nil
    user.save
  end
  
  def headers
    headers = []

    spreadsheet.row(1).each do |field|
      headers.push field.parameterize
    end
    
    headers
  end
  
  def file
    user.file
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
end