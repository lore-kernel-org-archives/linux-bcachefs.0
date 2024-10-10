Received: from www3564.sakura.ne.jp (www3564.sakura.ne.jp [49.212.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF401BBBC0
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728553209; cv=none; b=bB9dynO6q1kVOa3iVWoyeBTjAqjlNPRXsa4qfRMo7pS6IEdmZ2DMoY082rWG60tWhW9yForCMhT59SfGjNXTC11e0heoQ9SFWJgRAkKgcEbj82mqF3F66GrHdECPqoE/t26LnhW0jjSQY/yW093wkvZU5e+BW2yQ1ullqclqII4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728553209; c=relaxed/simple;
	bh=6vYICqJNO8O+We9XdZ5Uxmp2c0oQrw7BOhG2eOF71pM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AflQFpa42fVvaMlo/dXgpaLU3PKHryDXQk11VRXNEf45qGiGUCcPL8szE7RJHJxmeHEC/RkfV68QsudaiwRHoX7JJTEKrVfXHim+sQxLFdl2eP7Fh91+xZjsmmS6geIE/EL19QxiWHR9Qn8l8Sjd6OyQ8JAexy1e+kMKHdbA7FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=anyfrog.net; spf=pass smtp.mailfrom=anyfrog.net; dkim=pass (2048-bit key) header.d=anyfrog.net header.i=@anyfrog.net header.b=Ff4D7F6o; arc=none smtp.client-ip=49.212.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=anyfrog.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=anyfrog.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=anyfrog.net header.i=@anyfrog.net header.b="Ff4D7F6o"
Received: from fsav314.sakura.ne.jp (fsav314.sakura.ne.jp [153.120.85.145])
	by www3564.sakura.ne.jp (8.16.1/8.16.1) with ESMTP id 49A98mtU062353;
	Thu, 10 Oct 2024 18:08:48 +0900 (JST)
	(envelope-from kznrluk@anyfrog.net)
Received: from www3564.sakura.ne.jp (49.212.243.74)
 by fsav314.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp);
 Thu, 10 Oct 2024 18:08:48 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp)
Received: from aqua.. (27-89-54-24.v6plus.kamome.or.jp [27.89.54.24])
	(authenticated bits=0)
	by www3564.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 49A98mLJ062344
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 10 Oct 2024 18:08:48 +0900 (JST)
	(envelope-from kznrluk@anyfrog.net)
DKIM-Signature: a=rsa-sha256; bh=zIpTvsOOtINT66u9NLpzolz6ABqrlRarHX2LvU7sV5U=;
        c=relaxed/relaxed; d=anyfrog.net; h=Date:Message-ID:From:To:Subject;
        s=rs20240131; t=1728551328; v=1;
        b=Ff4D7F6oEM09Dy7qptXpUhtcTCKfs5APNyMr0cB4tNug0hQ4edkZ2HRjqdjif3g9I5vENwB6
        Rq29P3qVqFtuFL4Ag/GsV5Wu7jFWwLJ9nqGyCrLmd06tUp+TMp8tAe0h7vDwWRwBrA9NubFGa6/
        2+kyKVvxvY9kUT0C0djMVvww3niO/uIAeavOOo5s4IO+eKN2H4lOmzPiUHLkn44OuTR/kkFBqtl
        9jtPJSzVvzepca8PntAIT5u3Fpt65zpuU2gwY6br9OhJTzZCkPpr3c2nsqNpbbyp4zFCG9/Ieif
        W5M/KzB0/2YzAXu00EqamVuMERdWKh5vzoziu0Ug3me/w==
From: Kazunari Sasa <kznrluk@anyfrog.net>
To: linux-bcachefs@vger.kernel.org
Cc: Kazunari Sasa <kznrluk@anyfrog.net>
Subject: [PATCH] cmd_device_add: Allow setting durability when adding a device
Date: Thu, 10 Oct 2024 09:07:40 +0000
Message-ID: <20241010090739.31893-2-kznrluk@anyfrog.net>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Added a new --durability option to the device add command, allowing
users to specify the durability level for a new device.

Signed-off-by: Kazunari Sasa <kznrluk@anyfrog.net>
---
 c_src/cmd_device.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/c_src/cmd_device.c b/c_src/cmd_device.c
index c86fb7f1..86265214 100644
--- a/c_src/cmd_device.c
+++ b/c_src/cmd_device.c
@@ -52,6 +52,7 @@ static void device_add_usage(void)
 	     "  -B, --bucket=size           Bucket size\n"
 	     "  -D, --discard               Enable discards\n"
 	     "  -l, --label=label           Disk label\n"
+	     "  -d, --durability=value      Set durability level\n"
 	     "  -f, --force                 Use device even if it appears to already be formatted\n"
 	     "  -h, --help                  Display this help and exit\n"
 	     "\n"
@@ -65,6 +66,7 @@ int cmd_device_add(int argc, char *argv[])
 		{ "bucket",		required_argument,	NULL, 'B' },
 		{ "discard",		no_argument,		NULL, 'D' },
 		{ "label",		required_argument,	NULL, 'l' },
+		{ "durability",		required_argument,	NULL, 'd' },
 		{ "force",		no_argument,		NULL, 'f' },
 		{ "help",		no_argument,		NULL, 'h' },
 		{ NULL }
@@ -74,7 +76,7 @@ int cmd_device_add(int argc, char *argv[])
 	bool force = false;
 	int opt;
 
-	while ((opt = getopt_long(argc, argv, "S:B:Dl:fh",
+	while ((opt = getopt_long(argc, argv, "S:B:Dl:d:f:h",
 				  longopts, NULL)) != -1)
 		switch (opt) {
 		case 'S':
@@ -88,6 +90,11 @@ int cmd_device_add(int argc, char *argv[])
 		case 'D':
 			dev_opts.discard = true;
 			break;
+		case 'd':
+			if (kstrtouint(optarg, 10, &dev_opts.durability) ||
+				dev_opts.durability > BCH_REPLICAS_MAX)
+				die("invalid durability");
+			break;
 		case 'l':
 			dev_opts.label = strdup(optarg);
 			break;
-- 
2.47.0

