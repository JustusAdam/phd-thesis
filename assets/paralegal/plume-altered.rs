^#[paralegal::marker(user_data)]^
struct Comment { ... }

impl Database {
@\label{line:marker-assign}@  ^#[paralegal::marker(make_delete_query, arguments = [id])]^
  fn prepare_delete(&mut self, id: u32, table: &str) {...}
}

impl User {
  ^#[paralegal::analyze]^
  fn delete_user(&self, db: &mut Database) {
@\label{line:my-data}@    let my_data: UserData = self.get_my_data();
 @\label{line:builder-add-1}@   db.prepare_delete(self.id, "users");
 @\label{line:alt-execute}@   for post in &my_data.posts {
@\label{line:builder-add-2}@      db.prepare_delete(post.id, "posts");
    }
    (+for comment in &my_data.comments {+)
(+@\label{line:builder-add-3}@      db.prepare_delete(comment.id, "comments");+)
    (+}+)
@\label{line:builder-exec-1}@    db.execute();
  }
}
