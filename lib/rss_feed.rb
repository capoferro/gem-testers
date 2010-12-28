require 'tinyatom'

def generate_feed(rubygem)
  feed = TinyAtom::Feed.new(
    rubygem_url(rubygem),
    "Gem Test Results for #{rubygem.name}",
    rubygem_feed_url(rubygem),
  )

  # get the last 25 results for this gem.
  results = TestResult.joins(:version).
              where(["versions.rubygem_id = ?", rubygem.id]).
              order("test_results.created_at DESC").
              take(25)

  results.each do |result|
    feed.add_entry(
      result.id,
      "#{result.result ? "PASS" : "FAIL"} Test Result ##{result.id} for gem #{rubygem.name} version #{result.version.number}",
      result.created_at,
      rubygem_version_test_result_url(result.rubygem.name, result.version, result),
      :summary => "<code><pre>" + ERB::Util.html_escape(result.test_output) + "</pre></code>",
      :content => "<code><pre>" + ERB::Util.html_escape(result.test_output) + "</pre></code>"
    )
  end

  feed.make(:indent => 4)
end
