using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using BiomedSystem.ViewModels;
using BiomedSystem.Models;

namespace BiomedSystem.Pages
{
    public sealed partial class ResearchPlatformPage : Page
    {
        public ResearchPlatformViewModel ViewModel { get; }

        public ResearchPlatformPage()
        {
            this.InitializeComponent();
            ViewModel = new ResearchPlatformViewModel();
        }

        public string GetRoleText()
        {
            return ViewModel.IsTeacher ? "教师视图" : "学生视图";
        }
    }
}

// 扩展模型类以支持UI相关方法
namespace BiomedSystem.Models
{
    public partial class ResearchProject
    {
        public bool CanApply { get; set; } = true;
        public bool IsApplied { get; set; } = false;
        public bool IsUnderReview { get; set; } = false;

        public string GetApplicationButtonText()
        {
            if (IsUnderReview)
                return "审核中";
            if (IsApplied)
                return "已申请";
            return "申请";
        }

        public string GetStatusColor()
        {
            return Status switch
            {
                "进行中" => "#28a745",
                "已完成" => "#6f42c1",
                "已暂停" => "#ffc107",
                "已取消" => "#dc3545",
                _ => "#17a2b8"
            };
        }
    }

    public partial class ResearchSubmission
    {
        public string GetStatusColor()
        {
            return Status switch
            {
                "已发表" => "#28a745",
                "审核中" => "#ffc107",
                "被拒绝" => "#dc3545",
                "修改中" => "#17a2b8",
                _ => "#6c757d"
            };
        }
    }

    public partial class ResearchTask
    {
        public string GetPriorityColor()
        {
            return Priority switch
            {
                "高" => "#dc3545",
                "中" => "#ffc107",
                "低" => "#28a745",
                _ => "#6c757d"
            };
        }
    }
} 