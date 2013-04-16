# -*- encoding : utf-8 -*-
module CallCenterHelper
  include Dima::Html

  def cc_not_complete_tasks_list(tasks)
    task_table = TaskForm.task_table(tasks)
    task_table.item_actions.clear
    complete_url = lambda{ |v| call_complete_task_path(id: v.id) }
    task_table.actions << Action.new(icon: '/assets/fff/printer.png', label: ' ბეჭდვა', tooltip: 'რეესტრის ბეჭდვა', url: call_print_tasks_url)
    task_table.actions << Action.new(icon: '/assets/fff/arrow_refresh.png', label: 'სიქნრონიზაცია', tooltip: 'ჩაჭრა/აღდგენასთან სინქრონიზაცია', url: call_sync_tasks_url, method: :post, confirm: 'ნამდვილად გინდათ სინქრონიზაცია?')
    task_table.item_actions << Action.new(icon: '/assets/fff/tick.png', label: 'დასრულება', tooltip: 'დავალების დასრულება', url: complete_url, method: 'post', confirm: 'ნადვილად გინდათ დასრულება?')
    task_table.title = 'შეუსრულებელი დავალებები'
    task_table.html
  end
  
  def cc_tasks_list(tasks)
    task_table = TaskForm.task_table(tasks)
    task_table.item_actions.clear
    #add_url = lambda{ |v| call_add_to_favorites_path(id: v.id) }
    #task_table.actions << Action.new(icon: '/assets/fff/printer.png', label: ' ბეჭდვა', tooltip: 'რეესტრის ბეჭდვა', url: call_print_tasks_url)
    #task_table.actions << Action.new(icon: '/assets/fff/arrow_refresh.png', label: 'სიქნრონიზაცია', tooltip: 'ჩაჭრა/აღდგენასთან სინქრონიზაცია', url: call_sync_tasks_url, method: :post, confirm: 'ნამდვილად გინდათ სინქრონიზაცია?')
    #task_table.item_actions << Action.new(icon: '/assets/fff/heart_add.png', tooltip: 'ფავორიტებში დამატება', url: add_url, method: 'post')
    task_table.title = 'დავალებები'
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

  def cc_region_data_table(data)
    mobs_table = RegionDataForm.region_data_table(data)
    mobs_table.collapsed = true
    mobs_table.html
  end

  def cc_sms_table(task)
    sms_table = TaskForm.sms_table(task)
    sms_table.html
  end

end
