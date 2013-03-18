# -*- encoding : utf-8 -*-
module CallCenterHelper
  include Dima::Html

  def cc_not_complete_tasks_list(tasks)
    task_table = TaskForm.task_table(tasks)
    task_table.item_actions.clear
    add_url = lambda{ |v| call_add_to_favorites_path(id: v.id) }
    task_table.item_actions << Action.new(icon: '/assets/fff/heart_add.png', tooltip: 'ფავორიტებში დამატება', url: add_url, method: 'post')
    task_table.title = 'შეუსრულებელი დავალებები'
    task_table.html
  end

  def cc_favorites_table(favorites)
    favorites_table = TaskForm.task_table(favorites)
    favorites_table.item_actions.clear
    remove_url = lambda{ |v| call_remove_from_favorites_path(id: v.id) }
    favorites_table.item_actions << Action.new(icon: '/assets/fff/heart_delete.png', tooltip: 'ფავორიტებში წაშლა', url: remove_url, method: 'delete')
    favorites_table.title = 'ფავორიტები'
    favorites_table.icon = '/assets/fff/heart.png'
    favorites_table.html
  end

  def cc_status_table(stats)
    stat_table = StatusForm.stat_table(stats)
    stat_table.collapsed = true
    stat_table.html
  end

  def cc_mobiles_table(mobiles)
    mobs_table = MobilesForm.mobile_table(mobiles)
    mobs_table.collapsed = true
    mobs_table.html
  end

end
