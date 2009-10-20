var ThreadForm = {
  editNewTitle: function(txtField) {
    $('new_thread').innerHTML = (txtField.value.length > 5) ? txtField.value : 'New Thread';
  }
}

var LoginForm = {
  setToPassword: function() {
    $('openid_fields').hide();
    $('password_fields').show();
  },
  
  setToOpenID: function() {
    $('password_fields').hide();
    $('openid_fields').show();
  }
}

var ForumPostForm = {
	postId: null,

	reply: Behavior.create({
		onclick:function() {
    	ForumPostForm.cancel();
    	$('reply').toggle();
    	$('post_body').focus();
		}
	}),

	edit: Behavior.create(Remote.Link, {
		initialize: function($super, postId) {
			this.postId = postId;
			return $super();
		},
		onclick: function($super) {
			$('edit-post-' + this.postId + '_spinner').show();
			ForumPostForm.clearForumPostId();
			return $super();
		}
	}),
	
	cancel: Behavior.create({
		onclick: function() { 
			ForumPostForm.clearForumPostId(); 
			$('edit').hide()
			$('reply').hide()
			return false;
		}
	}),

  // sets the current post id we're editing
  editForumPost: function(postId) {
		this.postId = postId;
    $('post_' + postId + '-row').addClassName('editing');
		$('edit-post-' + postId + '_spinner').hide()
    if($('reply')) $('reply').hide();
		this.cancel.attach($('edit-cancel'))
		$('edit-form').observe('submit', function() { $('editbox_spinner').show() })
		setTimeout("$('edit_post_body').focus()", 250)
  },

  // checks whether we're editing this post already
  isEditing: function(postId) {
    if (ForumPostForm.postId == postId.toString())
    {
      $('edit').show();
      $('edit_post_body').focus();
      return true;
    }
    return false;
  },

  clearForumPostId: function() {
    var currentId = ForumPostForm.postId;
    if(!currentId) return;

    var row = $('post_' + currentId + '-row');
    if(row) row.removeClassName('editing');
		ForumPostForm.postId = null;
  }
}

var RowManager = {
  addMouseBehavior : function(ele){
    ele.onmouseover = function(e){ 
      ele.addClassName('thread_over'); 
    }

    ele.onmouseout = function(e){
      ele.removeClassName('thread_over');
    }
  }
};


Event.addBehavior({
	'#search, #reply': function() { this.hide() },
	'#search-link:click': function() {
		$('search').toggle();
		$('search_box').focus();
		return false
	},
          
  'tr.forum' : function() {
    RowManager.addMouseBehavior(this);
  },
          
  'tr.thread' : function(){
    RowManager.addMouseBehavior(this);
  },

	'tr.post': function() {
		var postId = this.id.match(/^post_(\d+)-/)[1]
    var anchor = this.down(".edit a")
    if(anchor) { ForumPostForm.edit.attach(anchor, postId) };
    RowManager.addMouseBehavior(this);
	},
	
	'#reply-link': function() {
		ForumPostForm.reply.attach(this)
	},
	
	'#reply-cancel': function() {
		ForumPostForm.cancel.attach(this)
	}
})
