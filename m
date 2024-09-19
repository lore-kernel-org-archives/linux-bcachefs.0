Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41101B2EE8;
	Thu, 19 Sep 2024 23:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726787289; cv=none; b=m8NS3INP+Exy7uaWYFWTYnKUo2McLn3MPV/SzMAKDy+0H7hP0ud6KlaaD01qvObRpjUIgOSpJEDmKOUnHTuJvgQA7vgDjJXKLfu3KcSJxnr/xQMKQeqEKkxQfxjr4gw/An7epz1hxUawekO6rekTXjYE3hxHDMqXs9MBE3UAuwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726787289; c=relaxed/simple;
	bh=kcJ9FPniXK4XD8DzmXUs15e7MYhkDa5d8MZGQterbsM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=W6fVY3FKpEZ5hiHrBahih9y3O3sSR/u7JipYH8s9QIjgYrgnuZiXDXiXk8dNWRs+446S8yvGzMr/IFEAPsEC2mCQwvCO+qDC4fd99+RH9hrptLudylN6vYBl/m8Ce16D3kh2HLPKkEUwaedo2JOisKtPHRkM3dwz3lwaDzZUGWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=NllGs2yc; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="NllGs2yc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1726787281; bh=ngiiRcFr65QAmddM4leUiyajDxrmIaKOksZVmxw1F7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NllGs2ycb58+mFgM81FQ7umxCNCitRQ8iHaj44Mw+S2El8mvSUFTfUb6ZbRFfVbjJ
	 qDGdJ7nUifQEb92h+hoNy8LRJmnHIkLtKdArZAGGyyYo+DDaBXnrmdGH0BJlUnFxSe
	 brpnWLzgLZvxs3KyDpykRaSXkJ5oz7gYCgDkwvOs=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszc5-2.qq.com (NewEsmtp) with SMTP
	id DD09BEB8; Fri, 20 Sep 2024 06:55:16 +0800
X-QQ-mid: xmsmtpt1726786516tgwp9pijj
Message-ID: <tencent_C2F02EF16C089514EB32EFFECC707A726F0A@qq.com>
X-QQ-XMAILINFO: MOpJcPT3Yy241ULNy4rFne4SDy2fD0+wUx0zPNP+MOs+jX+LMbglc8aYpdk+Sh
	 WYujE6cDAEbzzv7r8WPv/fCGiD9VzHE0L2sFGJFa6xsHzktW1mHJ4hY5/yZZLUOqNm500zgC/Geb
	 QDJW4ty385wrywyXf7es2mQXNOukLeqbKs4ze+/21PmHQmlKHdPWnxBHyJMgvBZHEj9+VWZxU+0a
	 K2uceNUwV+4kppz5bK64fMtCJLaYoPX8MMJXd60FLbwCahxYZ+OWkKL0Kcws9GISHbqaHciFl7e1
	 8ArI0sIuDXDKdzYTBWt9P6OCxrdbuMBMMMaVyGO5O6NBYZ9e0doPnusnsdrA/dd1aEbJTbb5AY4B
	 z0IM3OJo6Mcz5K13njajtmDaExLjlRPFobyVg5QncII6g4dopBlxeRsHWFRP9WcH0Qgsugm+/IHo
	 XH+iHoxphnoE1/OfnVsb2Xv/SzQADZu21ayj8C5VzYfQUyjilxl0Umu6+Bv4CB44eG2hkNeQWqMp
	 +Nw/a4WVpWAR5PQTuECFHCOeXt36hpzPRihh5yPmra8nXI/UnlulTGFeFGXJAhabc8buKjOWJ6UF
	 lHOsatG0nI5JnsTdvWsNuUcBdN6QZxQjiR1K/rXLDDVjeuJIZMc3sqRNnSpeaoehVmaPqhLNSAjs
	 qlm2YbwGJbVVhRxuuk2nYI1JrUDVFuYnlcf0+FSwniuNMopIXwll9TFwvRi2yLJ1z/COH2JzFdAB
	 pHfW1XxqqJWuB8TE4nITP8U2qJOpy1AD4bv7i/kEgfXvWztSY2abkr6m/Deh1+rr9zdzHzaJJFwb
	 ULlkWP3u575sHYx7Y8TeOyZKYdH1aPqP5DKrIQGmZet8LBDb2TF2MQTBRHzizLhvlQAx6jrJF2RT
	 /9Hh7xgHbdJ4uboniVUKSONF5sttjT8r3mKZtlswaN0VghhuurHPjm5BsvAiCz0A==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+294f528e56138c357a48@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] bcachefs: Fix null-ptr-deref in bch2_opt_to_text
Date: Fri, 20 Sep 2024 06:55:17 +0800
X-OQ-MSGID: <20240919225516.228808-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <66eb6254.050a0220.92ef1.0009.GAE@google.com>
References: <66eb6254.050a0220.92ef1.0009.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mounting option values passed in by syzbot are:
"metadata_checksum=crc64, errors=continue, obj_user={^, subj_user=obj_ur,
approve", which does not meet the "key1=value1,key2=value2,..." requirement
of the bcachefs.

Reported-and-tested-by: syzbot+294f528e56138c357a48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=294f528e56138c357a48
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/bcachefs/opts.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e10fc1da71b1..78307e092075 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -472,6 +472,12 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
 	u64 v;
 	int ret, id;
 
+	if (!val) {
+		pr_err("Bad mount option, value is NULL");
+		ret = -BCH_ERR_option_value;
+		goto out;
+	}
+
 	id = bch2_mount_opt_lookup(name);
 
 	/* Check for the form "noopt", negation of a boolean opt: */
-- 
2.43.0

