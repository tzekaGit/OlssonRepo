using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Olsson.Mobile.Api.Controllers;
using System.Collections.Generic;
using Olsson.Mobile.Api;
using Microsoft.AspNet.Identity.Owin;
using Olsson.Mobile.Api.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Moq;

namespace General_Test
{
    [TestClass]
    public class AccountControllerTest
    {
        [TestMethod]
        public void TestMethod1()
        {

            //setup
            var ctrl = new AccountController(FakeUserManager());


            //act
            var result = ctrl.GetManageInfo("return url").Result;


            //assert
            Assert.Equals(result.Email, "test@test.com");

        }

        protected ApplicationUserManager FakeUserManager()
        {
            var user = new ApplicationUser() {UserName = "aaa", Email = "bbb"};
            var fakeUser = new Mock<IUserStore<ApplicationUser>>(user);;

            return new ApplicationUserManager(fakeUser.Object);
        }

    }
}
