module TestResultsHelper
  def filter_ansi(text)
    text.gsub(/\e[^a-z]+[a-z]/, '')
  end
end
