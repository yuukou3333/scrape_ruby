# htmlの取得 ==============================
require 'net/http'

def get_from(url)  # 引数に渡されたURLを取得し、HTMLを取得するメソッド
  Net::HTTP.get(URI(url))
end

def write_file(path, text)  # 取得したHTMLをファイルにまとめるメソッド
  File.open(path, 'w') { |file| file.write(text) }
end

# write_file('pitnews.html', get_from('https://masayuki14.github.io/pit-news/'))
# HTMLを引数に入れる入力

# 取得したHTMLから要素をデータとして保存 ======================
require 'nokogiri'

html = File.open('pitnews.html', 'r') { |f| f.read } # html読み込み
doc = Nokogiri::HTML.parse(html, nil, 'utf-8') # HTMLをプログラムが扱いやすいように構文分析してくれる

pitnews = []
doc.xpath('/html/body/main/section').each_with_index do |section, index|
  next if index.zero?  # indexが０のやつを見たら飛ばして

  contents = {category: nil, news: []}
  # コンテンツにcategoryとnewsのデータをハッシュ形式で保存
  contents[:category] = section.xpath('./h6').first.text
  # categoryのなか（現在はnil）にロケーションパスのテキストを代入


  section.xpath('./div/div').each do |node|  # ロケーションパスの内容を繰り返し
    title = node.xpath('./p/strong/a').first.text  # テキストを取得
    url = node.xpath('./p/strong/a').first['href']   # 属性を取得

    news = {title: title, url: url}
    contents[:news] << news # 取得したnewsを代入（配列にpushメソッドで入れている）
  end
  pitnews << contents  # pitnewsにぶち込む
end

# 保存したデータをJSON形式で格納 ======================-
require 'json'
File.open('pitnews.json', 'w') { |file| file.write({pitnews: pitnews}.to_json)}
