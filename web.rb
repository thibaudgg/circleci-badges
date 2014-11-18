require 'sinatra'
require 'open-uri'
require 'multi_xml'
require 'digest/sha1'

get '/:owner/:repo/:token' do
  url = "https://circleci.com/gh/#{params[:owner]}/#{params[:repo]}.cc.xml?circle-token=#{params[:token]}"
  xml = open(url).read
  status = MultiXml.parse(xml)['Projects']['Project']['lastBuildStatus']
  badge = status == 'Success' ? 'build-passing-brightgreen.svg' : 'build-failing-red.svg'
  badge = "https://img.shields.io/badge/#{badge}"

  etag Digest::SHA1.base64digest(badge)
  cache_control :no_cache, :no_store
  headers 'Content-Type' => 'text/svg+xml'

  open(badge).read
end
