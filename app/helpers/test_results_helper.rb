module TestResultsHelper
  def filter_ansi(text)
    text.gsub(/\e[^a-z]+[a-z]/, '')
  end
  
  def clippy(text)
    render :partial => "shared/clippy", :locals => {:text => text}
  end
end
