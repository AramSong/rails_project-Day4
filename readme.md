## Day 4

#### 지난주 간단과제 - twitter 만들기.

```
$ rails g model board contents ip_address

$ rails d model board

$ rails g model board contents:text //contents column type을 text로 정해줌 ; default는 string

controller tweet (액션명index,new,show,edit)	//controller 명령어 뒤에 액션명을 명시하면 view파일과 route파일이 자동으로 생성된다.

root 	//도메인이 처음으로 갈 때, 어디로 갈지 지정해준다.
```

- route가 정상적으로 등록됐나 확인

```
$ rake routes
```

* routes.rb 파일 구성시

```
get '/tweet/new' => 'tweet#new'			//위치 중요. 반드시 new가 show 앞에
get '/tweet/:id' => 'tweet#show'
```

* *Action View Form Helper*
  - rails form helper : view helper의 일종. 간단한 form_tag로 html_tag를 대체가능.

```
<%= form_tag do %>
	Form contents
<% end %>
```

​									↓

```

<form accept-charset="UTF-8" action="/" method="post">
  <input name="utf8" type="hidden" value="&#x2713;" />
  <input name="authenticity_token" type="hidden" value="J7CBxfHalt49OSHp27hblqK20c9PgwJ108nDHX/8Cts=" />
  Form contents
</form>
```

```
<%= form_tag("/search", method: "get") do %>
  <%= label_tag(:q, "Search for:") %>
  <%= text_field_tag(:q) %>
  <%= submit_tag("Search") %>
<% end %>
```

​									↓

```
<form accept-charset="UTF-8" action="/search" method="get">	//DEFAULT 는 'POST'
  <input name="utf8" type="hidden" value="&#x2713;" />
  <label for="q">Search for:</label>
  <input id="q" name="q" type="text" />
  <input name="commit" type="submit" value="Search" />
</form>
```

* new.html.erb :  form helper로 변경

```ruby
<%= form_tag('/tweet/create') do %>
	<p align="right">
		<input class="form-control" type="text" name="contents" placeholder="무슨 일이 일어나고 있나요?">
		<br><br>
		<input class="btn btn-info" type="submit" value="트윗">
	</p>
<% end %>
```

​									↓

```ruby
		<%=text_area_tag :contents, nil, class: "form-control"%>
		<br><br>
		<%=submit_tag "작성하기",class:"btn btn-info" %>
```

* form helper는 기본적으로 view helper. 

  ````
   <%=link_to truncate(tweet.contents,length:10),"/tweet/#{tweet.id}"%>
  ````

* 글자 제한 : length 제한

```
truncate("Once upon a time in a world far far away", length: 17)
```

* 동작을 완료했을 때 보여주는 메시지: flash



### 쿠키와 세션

------



* 하나의 요청이가고 응답이 오면, 다시 요청이가고 응답이 가는 것은 별개의 일이다.

* connection이 독립적?

  => 모든 요청과 응답은 각각 독립적이다. 독립적인 것을 해결하기 위해 고안된게 cookie

  * cookie: 지속적으로 정보를 유지하고자 할 때.(정보와 상태가 사용자 혹은 서버에서 삭제할 때까지 정보가 계속 유지된다.) 서버가 사용자의 웹 브라우저에 전송하는 작은 데이터 조각. 브라우저는 그 데이터 조각들을 저장할 수 있고, 동일한 서버로 다음 요청 시 함께 전송.

    ***쿠키는 상태가없는 HTTP 프로토콜에서 상태기반 정보를 기억한다.***

    - 세션관리, 개인화,  트래킹

  * ex) 사용자가 로그아웃, 특정시간이 지나면 로그아웃, 브라우저를 껐을 때 사라지는 경우

  * session: 암호화하여 사용하는 것. 암호화된 해시가 들어있다. 쿠키는 여러개, 세션은 하나

* ex) 장바구니.

  ​	1) 모바일 app장바구니 정보가 브라우저에도 같이 보인다면? 서버 db에 저장되어 있기 때문.

  ​	2) 모바일 app장바구니 정보가 브라우저에 보이지않는다면? 쿠키에 저장(클라이언트에 저장)

* flash ≒ cookie (휘발성. flash도 일종의 쿠키/session)

`tweet_controller.rb/create`

```
 flash[:success] = "새 글이 등록되었습니다."
```

`layouts/application.html.erb`: key자체로 method 를 불러오고 해당하는 메시지(value)를 띄워줌.

```html
<% flash.each do |key,value| %>
        <script>
          toastr.<%= key %>("<%=value %>");
        </script>
<% end %>
```

