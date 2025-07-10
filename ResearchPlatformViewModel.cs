using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Windows.Input;
using BiomedSystem.Models;
using BiomedSystem.Services;

namespace BiomedSystem.ViewModels
{
    public class ResearchPlatformViewModel : INotifyPropertyChanged
    {
        private readonly ApiClient _apiClient;
        private readonly IUserStore _userStore;
        private User _currentUser;

        public event PropertyChangedEventHandler PropertyChanged;

        // 集合属性
        public ObservableCollection<ResearchProject> AvailableProjects { get; } = new();
        public ObservableCollection<ResearchProject> TeacherProjects { get; } = new();
        public ObservableCollection<ResearchTask> Tasks { get; } = new();
        public ObservableCollection<ResearchApplication> PendingApplications { get; } = new();
        public ObservableCollection<ResearchSubmission> Submissions { get; } = new();

        // 用户角色属性
        public bool IsTeacher => _currentUser?.Role == 2;
        public bool IsStudent => _currentUser?.Role == 1;

        // 命令属性
        public ICommand ApplyForProjectCommand { get; }
        public ICommand ViewProjectDetailsCommand { get; }
        public ICommand EditProjectCommand { get; }
        public ICommand ManageApplicationsCommand { get; }
        public ICommand ApproveApplicationCommand { get; }
        public ICommand RejectApplicationCommand { get; }
        public ICommand UpdateTaskProgressCommand { get; }
        public ICommand ViewTaskDetailsCommand { get; }
        public ICommand DownloadPaperCommand { get; }
        public ICommand ViewSubmissionDetailsCommand { get; }

        public ResearchPlatformViewModel()
        {
            _apiClient = new ApiClient();
            _userStore = new UserStore();
            
            // 初始化命令
            ApplyForProjectCommand = new RelayCommand<ResearchProject>(ApplyForProject);
            ViewProjectDetailsCommand = new RelayCommand<ResearchProject>(ViewProjectDetails);
            EditProjectCommand = new RelayCommand<ResearchProject>(EditProject);
            ManageApplicationsCommand = new RelayCommand<ResearchProject>(ManageApplications);
            ApproveApplicationCommand = new RelayCommand<ResearchApplication>(ApproveApplication);
            RejectApplicationCommand = new RelayCommand<ResearchApplication>(RejectApplication);
            UpdateTaskProgressCommand = new RelayCommand<ResearchTask>(UpdateTaskProgress);
            ViewTaskDetailsCommand = new RelayCommand<ResearchTask>(ViewTaskDetails);
            DownloadPaperCommand = new RelayCommand<ResearchSubmission>(DownloadPaper);
            ViewSubmissionDetailsCommand = new RelayCommand<ResearchSubmission>(ViewSubmissionDetails);

            InitializeAsync();
        }

        private async void InitializeAsync()
        {
            _currentUser = await _userStore.GetUserAsync();
            OnPropertyChanged(nameof(IsTeacher));
            OnPropertyChanged(nameof(IsStudent));

            if (IsStudent)
            {
                await LoadAvailableProjectsAsync();
                await LoadMyTasksAsync();
                await LoadMySubmissionsAsync();
            }
            else if (IsTeacher)
            {
                await LoadTeacherProjectsAsync();
                await LoadPendingApplicationsAsync();
                await LoadTeacherTasksAsync();
                await LoadTeacherSubmissionsAsync();
            }
        }

        // 学生相关方法
        private async Task LoadAvailableProjectsAsync()
        {
            try
            {
                var projects = await _apiClient.GetAvailableProjectsAsync();
                AvailableProjects.Clear();
                foreach (var project in projects)
                {
                    AvailableProjects.Add(project);
                }
            }
            catch (Exception ex)
            {
                // 处理错误
                System.Diagnostics.Debug.WriteLine($"加载可申请项目失败: {ex.Message}");
            }
        }

        private async Task LoadMyTasksAsync()
        {
            try
            {
                var tasks = await _apiClient.GetMyTasksAsync();
                Tasks.Clear();
                foreach (var task in tasks)
                {
                    Tasks.Add(task);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"加载我的任务失败: {ex.Message}");
            }
        }

        private async Task LoadMySubmissionsAsync()
        {
            try
            {
                var submissions = await _apiClient.GetMySubmissionsAsync();
                Submissions.Clear();
                foreach (var submission in submissions)
                {
                    Submissions.Add(submission);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"加载我的投稿失败: {ex.Message}");
            }
        }

        // 教师相关方法
        private async Task LoadTeacherProjectsAsync()
        {
            try
            {
                var projects = await _apiClient.GetTeacherProjectsAsync();
                TeacherProjects.Clear();
                foreach (var project in projects)
                {
                    TeacherProjects.Add(project);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"加载教师项目失败: {ex.Message}");
            }
        }

        private async Task LoadPendingApplicationsAsync()
        {
            try
            {
                var applications = await _apiClient.GetPendingApplicationsAsync();
                PendingApplications.Clear();
                foreach (var application in applications)
                {
                    PendingApplications.Add(application);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"加载待审核申请失败: {ex.Message}");
            }
        }

        private async Task LoadTeacherTasksAsync()
        {
            try
            {
                var tasks = await _apiClient.GetTeacherTasksAsync();
                Tasks.Clear();
                foreach (var task in tasks)
                {
                    Tasks.Add(task);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"加载教师任务失败: {ex.Message}");
            }
        }

        private async Task LoadTeacherSubmissionsAsync()
        {
            try
            {
                var submissions = await _apiClient.GetTeacherSubmissionsAsync();
                Submissions.Clear();
                foreach (var submission in submissions)
                {
                    Submissions.Add(submission);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"加载教师投稿失败: {ex.Message}");
            }
        }

        // 命令实现方法
        private async void ApplyForProject(ResearchProject project)
        {
            try
            {
                // 更新按钮状态为"审核中"
                project.IsUnderReview = true;
                project.CanApply = false;
                OnPropertyChanged(nameof(AvailableProjects));

                var success = await _apiClient.SubmitApplicationAsync(project.Id, "申请参与该研究项目");
                
                if (success)
                {
                    // 申请成功，保持审核中状态
                    System.Diagnostics.Debug.WriteLine($"成功申请项目: {project.Title}");
                }
                else
                {
                    // 申请失败，恢复原状态
                    project.IsUnderReview = false;
                    project.CanApply = true;
                    OnPropertyChanged(nameof(AvailableProjects));
                }
            }
            catch (Exception ex)
            {
                // 发生错误，恢复原状态
                project.IsUnderReview = false;
                project.CanApply = true;
                OnPropertyChanged(nameof(AvailableProjects));
                System.Diagnostics.Debug.WriteLine($"申请项目失败: {ex.Message}");
            }
        }

        private void ViewProjectDetails(ResearchProject project)
        {
            // 实现查看项目详情逻辑
            System.Diagnostics.Debug.WriteLine($"查看项目详情: {project.Title}");
        }

        private void EditProject(ResearchProject project)
        {
            // 实现编辑项目逻辑
            System.Diagnostics.Debug.WriteLine($"编辑项目: {project.Title}");
        }

        private void ManageApplications(ResearchProject project)
        {
            // 实现管理申请逻辑
            System.Diagnostics.Debug.WriteLine($"管理项目申请: {project.Title}");
        }

        private async void ApproveApplication(ResearchApplication application)
        {
            try
            {
                var success = await _apiClient.ReviewApplicationAsync(application.Id, true, "申请通过");
                if (success)
                {
                    PendingApplications.Remove(application);
                    System.Diagnostics.Debug.WriteLine($"已批准申请: {application.StudentName}");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"批准申请失败: {ex.Message}");
            }
        }

        private async void RejectApplication(ResearchApplication application)
        {
            try
            {
                var success = await _apiClient.ReviewApplicationAsync(application.Id, false, "申请被拒绝");
                if (success)
                {
                    PendingApplications.Remove(application);
                    System.Diagnostics.Debug.WriteLine($"已拒绝申请: {application.StudentName}");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"拒绝申请失败: {ex.Message}");
            }
        }

        private void UpdateTaskProgress(ResearchTask task)
        {
            // 实现更新任务进度逻辑
            System.Diagnostics.Debug.WriteLine($"更新任务进度: {task.Title}");
        }

        private void ViewTaskDetails(ResearchTask task)
        {
            // 实现查看任务详情逻辑
            System.Diagnostics.Debug.WriteLine($"查看任务详情: {task.Title}");
        }

        private async void DownloadPaper(ResearchSubmission submission)
        {
            try
            {
                // 实现下载论文逻辑
                await _apiClient.DownloadSubmissionAsync(submission.Id);
                System.Diagnostics.Debug.WriteLine($"开始下载论文: {submission.Title}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"下载论文失败: {ex.Message}");
            }
        }

        private void ViewSubmissionDetails(ResearchSubmission submission)
        {
            // 实现查看投稿详情逻辑
            System.Diagnostics.Debug.WriteLine($"查看投稿详情: {submission.Title}");
        }

        protected virtual void OnPropertyChanged(string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }

    // RelayCommand 实现
    public class RelayCommand<T> : ICommand
    {
        private readonly Action<T> _execute;
        private readonly Predicate<T> _canExecute;

        public RelayCommand(Action<T> execute, Predicate<T> canExecute = null)
        {
            _execute = execute ?? throw new ArgumentNullException(nameof(execute));
            _canExecute = canExecute;
        }

        public bool CanExecute(object parameter)
        {
            return _canExecute?.Invoke((T)parameter) ?? true;
        }

        public void Execute(object parameter)
        {
            _execute((T)parameter);
        }

        public event EventHandler CanExecuteChanged
        {
            add { }
            remove { }
        }
    }
} 