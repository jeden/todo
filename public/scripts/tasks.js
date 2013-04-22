/*
 Copyright (c) 2013 Antonio Bello
 https://github.com/jeden/todo

 MIT License

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to
 deal in the Software without restriction, including without limitation the
 rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 sell copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 DEALINGS IN THE SOFTWARE.
*/

function TaskController($scope, $http) {
	var DEFAULT_PRIORITY = 2; // NORMAL
	var _lastId = 0;
	var _editedTaskId = null;

	__loadTasks();

	$scope.editPriority = 2

	$scope.saveTask = function() {
		var isNew = false;
		var task = {
			_id: $scope.editId,
			description: $scope.editDescription,
			priority: $scope.editPriority,
			completed: $scope.editCompleted
		};

		if (!task._id) {
			task._id = --_lastId;
			isNew = true;
		}

		if (isNew) {
			__createTask(task);
		} else {
			__updateTask(task);
		}
		_editedTaskId = null;
		__clearForm();
	}

	$scope.editTask = function($event, taskId) {
		_editedTaskId = taskId;
		task = $scope.tasks[taskId];
		$scope.editId = task._id;
		$scope.editDescription = task.description;
		$scope.editPriority = task.priority;
		$scope.editCompleted = task.completed;
	}

	$scope.cancelEditTask = function() {
		_editedTaskId = null;
		__clearForm();
	}

	$scope.deleteTask = function($event, taskId) {
		__deleteTask(taskId);
		_editedTaskId = null;
		__clearForm();
	}

	$scope.isNewTask = function () {
		return ($scope.editId == 0) || (typeof $scope.editId === 'undefined');
	}

	$scope.changeTaskStatus = function(taskId) {
		var task = $scope.tasks[taskId];
		if (_editedTaskId == taskId) {
			$scope.editCompleted = task.completed;
		}
		__updateTask(task)
	}

	$scope.sortFunc = function(task) {
		val = (task.completed ? 1 : 0) * 10000000;
		val += (10 - task.priority) * 1000000;

		var multiplier = 26 * 26 * 26;
		for (var count = 0; count < 3; ++count) {
			if (task.description.length > count) {
				var char = task.description.substring(count, count + 1).toUpperCase().charCodeAt(0);
				val += char * multiplier;
				multiplier /= 26;
			}
		}

		console.log(val)

		return val;
	}

	function __clearForm() {
		$scope.editId = 0;
		$scope.editDescription = '';
		$scope.editPriority = DEFAULT_PRIORITY;
		$scope.editCompleted = 0;
	}

	function __loadTasks() {
		$http.get('/backoffice/api/tasks').success(function(data) {
			tasks = {}
			for(taskIndex in data) {
				var task = data[taskIndex];
				if ('_id' in task) {
					tasks[task._id] = task;
				}
			}
			$scope.tasks = tasks;
			$scope.tasksArray = [];
			for (key in tasks) {
				$scope.tasksArray.push($scope.tasks[key])
			}
		})
	}

	function __createTask(task) {
		if ('_id' in task) {
			delete task._id;
		}

		$http.put('/backoffice/api/tasks', {task: task} ).success(function(data) {
			__loadTasks();
		})
	}

	function __updateTask(task) {
		$http.post('/backoffice/api/tasks/' + task._id, {task: task}).success(function(data) {
			__loadTasks();
		})
	}

	function __deleteTask(taskId) {
		$http.delete('/backoffice/api/tasks/' + taskId).success(function(data) {
			__loadTasks();
		})
	}
}

