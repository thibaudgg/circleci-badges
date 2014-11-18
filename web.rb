require 'sinatra'
require 'open-uri'
require 'multi_xml'

get '/:owner/:repo/:token' do
  url = "https://circleci.com/gh/#{params[:owner]}/#{params[:repo]}.cc.xml?circle-token=#{params[:token]}"
  xml = open(url).read
  status = MultiXml.parse(xml)['Projects']['Project']['lastBuildStatus']
  badge = status == 'Success' ? 'build-passing-brightgreen.svg' : 'build-failing-red.svg'

  headers \
    'Pragma' => 'no-cache',
    'Cache-Control' => 'no-cache',
    'Age' => 0

  redirect "https://img.shields.io/badge/#{badge}"
end
