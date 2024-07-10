Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3766E18EFF9
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jul 2024 09:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720604007; cv=none; b=GBaTqIY3yDk6Xpy3cXMY9JEhR0rLZXBLMYVB8v4WQMr1+Fp1o1AW+yGiJUOkAdNgR3hFF6+BTrwJWXE6ZFCN4RzLw2AXRW0PJNXLJ+vu51ZaV7tDSGpGnPIalqCSgij5oQ6t7kMfaEDqG+L5kPGtEwm4J0FSeEUsB+sl33Qh+ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720604007; c=relaxed/simple;
	bh=3+9DMfYTCxGjnK/e+W8XKa3FLEaY8rQkVl7tyylyIMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huHqLfHAOAG682k5R/aluBe7SywoLidStmHkwAv9oa4H8KCRx8xDzfjK/LqOYcwKb/A2OuyiDslKc0jmlIEyQVHRebK4q90kvam3aZ1cicdzqTHgHaOjuN7+IJtYZRovhK2aXy2e/bgNk4eJIrK1QvM3/Ogq3g+0ax1O2LqO258=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=ZWPiFYHM; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="ZWPiFYHM"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4266f4b29f5so1623725e9.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jul 2024 02:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1720604002; x=1721208802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TzeNSBzyh7QLIzCzfuneqEVx7/nkOlCs6tKZ3S/B85c=;
        b=ZWPiFYHMgh1dXUqQbdlPbEZ+gN7mwJCmBCMEmHaErmXwDXIHA3TLHpX3jqsFuHw4a2
         9qSQCHNZcPJKHxFf5GJMHVQyg9mdrK7kPJzyZm3J81dEThDk/Nk4hlWNno6gcLX6x3rA
         tSBEow6qYe99JrCVrC1Nhi9ylDywJGcCu3+s0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720604002; x=1721208802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TzeNSBzyh7QLIzCzfuneqEVx7/nkOlCs6tKZ3S/B85c=;
        b=O8tHx30M+e0brn8O4t2+kd9Cx2U4uLwe+sUaWawwfDNK5Sj+pwR7UKJVVyLMMQC41B
         8HOKYrsAdmE6LnfHYyH0iD2E+mnxuTX9RhaJNxyR8g+GD3DxWOmZilauCiujhhfO5sxy
         5Oql1gvfy2+N5oNwP42QMH/pCGqdfhAXHuWY9gZ2sUJzAIe+aSAEaOPWQiqKAQPuzX0T
         eAbjXGGpJlScqlGre0R9/RSs5yjs3d4txoolb+QoI4jcZ8lNOBl9TtbOygGqVqsC0AYX
         swYmP7m21zt4NC4cpvtJ/gonRkZInogWrX7eOU8K+2WBgdod32xNMAeFCPaSgx1/Ez7N
         dSqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUH1LsLYVHYH3PkCmSVSiiBLy8pFugfXgrlA+U2/s2ovCdI0IRUl9Om45n2nq12lV8hyKoeWFpLOCWNM4fAJ8kHRB2FDLw9jCy2dg/ph5M=
X-Gm-Message-State: AOJu0YwMJ7iBqN3ai+nokop9bZe+KMbq/o6/4POjvOKp4NKY80dyFYOt
	ijsch5SSodazUIvhFaEigdQOSxk9TW/EstIegOnYCm4XeBizv0AlQaThsRYftrg=
X-Google-Smtp-Source: AGHT+IFAxrCbKthPgF5yUWY01P3adBGwJNfKLQpHeukxHdQeDqaphx4o5novPlwU23HfZb9BgXrQug==
X-Received: by 2002:a05:600c:3b86:b0:426:5dd5:f245 with SMTP id 5b1f17b1804b1-426708f1979mr35047955e9.2.1720604002571;
        Wed, 10 Jul 2024 02:33:22 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266f6f5a27sm73448935e9.23.2024.07.10.02.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 02:33:22 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	syzbot+6cebc1af246fe020a2f0@syzkaller.appspotmail.com,
	Daniel Vetter <daniel.vetter@intel.com>,
	stable@vger.kernel.org,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 2/2] bcachefs: only console_trylock in bch2_print_string_as_lines
Date: Wed, 10 Jul 2024 11:31:17 +0200
Message-ID: <20240710093120.732208-2-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240710093120.732208-1-daniel.vetter@ffwll.ch>
References: <20240710093120.732208-1-daniel.vetter@ffwll.ch>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

console_lock is the outermost subsystem lock for a lot of subsystems,
which means get/put_user must nest within. Which means it cannot be
acquired somewhere deeply nested in other locks, and most definitely
not while holding fs locks potentially needed to resolve faults.

console_trylock is the best we can do here.

Including printk folks since even trylock feels realyl iffy here to
me.

Reported-by: syzbot+6cebc1af246fe020a2f0@syzkaller.appspotmail.com
References: https://lore.kernel.org/dri-devel/00000000000026c1ff061cd0de12@google.com/
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Fixes: a8f354284304 ("bcachefs: bch2_print_string_as_lines()")
Cc: <stable@vger.kernel.org> # v6.7+
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 fs/bcachefs/util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index de331dec2a99..02381c653603 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -255,13 +255,14 @@ void bch2_prt_u64_base2(struct printbuf *out, u64 v)
 void bch2_print_string_as_lines(const char *prefix, const char *lines)
 {
 	const char *p;
+	int locked;
 
 	if (!lines) {
 		printk("%s (null)\n", prefix);
 		return;
 	}
 
-	console_lock();
+	locked = console_trylock();
 	while (1) {
 		p = strchrnul(lines, '\n');
 		printk("%s%.*s\n", prefix, (int) (p - lines), lines);
@@ -269,7 +270,8 @@ void bch2_print_string_as_lines(const char *prefix, const char *lines)
 			break;
 		lines = p + 1;
 	}
-	console_unlock();
+	if (locked)
+		console_unlock();
 }
 
 int bch2_save_backtrace(bch_stacktrace *stack, struct task_struct *task, unsigned skipnr,
-- 
2.45.2

