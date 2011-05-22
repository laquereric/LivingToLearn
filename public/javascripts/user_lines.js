  function add_user_marketing_context(form,user_id,marketing_context_id) {
    form.action = 'user/' + user_id + '/add_marketing_context/' + marketing_context_id
    form.submit()
  }
  function select_user_marketing_context(form,user_id,marketing_context_id) {
    form.action = 'user/' + user_id + '/select_marketing_context/' + marketing_context_id
    form.submit()
  }
  function onLoad(){
    <%= yield :onload_script -%>
  }

