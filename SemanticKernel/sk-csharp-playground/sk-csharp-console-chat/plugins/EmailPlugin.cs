using System.ComponentModel;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.AI.ChatCompletion;

namespace Plugins;

/// <summary>
/// A Sematic Kernel skill that interacts with ChatGPT
/// </summary>
internal class EmailPlugin
{
    [KernelFunction("SendEmail")]
    [Description("Sends an email to a recipient.")]
    public async Task SendEmailAsync(
        [Description("Semicolon delimitated list of emails of the recipients")] string recipientEmails,
        string subject,
        string body
    )
    {
        await Task.Delay(1000);
        // Add logic to send an email using the recipientEmails, subject, and body
        // For now, we'll just print out a success message to the console
        Console.WriteLine("Email sent!");
        Console.WriteLine($"Email: {subject}, {body} to {recipientEmails}");
    }
}
