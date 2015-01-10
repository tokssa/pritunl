library users;

import 'package:pritunl/collection.dart' as collection;
import 'package:pritunl/models/user.dart' as user;

import 'package:angular/angular.dart' show Injectable;
import 'package:angular/angular.dart' as ng;
import 'dart:math' as math;

@Injectable()
class Users extends collection.Collection {
  var model = user.User;
  var org_id;
  var hidden;
  var page;
  var page_total;
  var pages;

  get url {
    return '/user/${this.org_id}?page=${this.page}';
  }

  Users(ng.Http http) :
    page = 0,
    super(http);

  parse(data) {
    this.page = data['page'].toInt();
    this.page_total = data['page_total'].toInt();
    this._updatePages();

    return data['users'];
  }

  _updatePages() {
    this.pages = [];

    if (this.page_total < 2) {
      print(this.pages);
      return;
    }

    var i;
    var isCurPage;
    var cur = math.max(0, this.page - 7);

    this.pages.add([this.page == 0, 'First']);

    for (i = 0; i < 15; i++) {
      isCurPage = cur == this.page;
      if (cur > this.page_total - 1) {
        break;
      }
      if (cur > 0) {
        this.pages.add([isCurPage, cur + 1]);
      }
      cur += 1;
    }

    pages.add([isCurPage, 'Last']);

    this.pages = pages;
  }

  next() {
    this.page += 1;
    this.fetch();
  }

  prev() {
    this.page -= 1;
    this.fetch();
  }

  onPage(page) {
    if (page == 'First') {
      page = 0;
    }
    else if (page == 'Last') {
      page = this.page_total;
    }
    else {
      page -= 1;
    }
    this.page = page;
    this.fetch();
  }
}
