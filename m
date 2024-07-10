Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A44019149B
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jul 2024 13:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720616623; cv=none; b=KiitYMborD0BGw9ZEcU2ZpwwUOHnYP23mH5mecwjuRIKJz9XFfEUDlzO6U4m6FG38QrPvI0AQfgEzlFTN0Gdymn5mlrwFpbLxAj8mIJft/5kuOeSn9ABLAaYpJZoc33WGnZxyYwMQbchJGBCpR6D+nW2av+PkkZlSMIpoUNOZP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720616623; c=relaxed/simple;
	bh=u4xe50Y/QnZQ4d7+yhyKPuJj8WeSEb6DPqcYwez31JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTEcgVxWbiUjfekWVRhsP1AEqzA6T/EnNkNO9Lnln+/lSL+EByVtg407G59wW/G/6bYke5dhyrhcThmE/3zuDwy8ksYkZi5IYHJHNbxD81F/8NEn/CAqYeyIp01GNs8XVND2F28zRI/WL0kucAKtpI9Zv5MSv3va4I2ROlFyiMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=dAWPH7SA; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="dAWPH7SA"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-426719e2efeso2692135e9.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jul 2024 06:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1720616619; x=1721221419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWYvLutVvpNPgBageJj8H8A/uQDi1vyHTGEzq9IVLnI=;
        b=dAWPH7SA9zj7+TlYREoMYWujdKZJsCadj6LW8Ulhws8E5LHkPLB6zJYwiY7UmQvleL
         wZ9SLP+G6uGlqQ244smnTgavyPaqnZ3vIyx+ovUTOPatznENuUBpKPtC9ckfK3XEyKhf
         cNfoewKFykklA6rnV14cYHjO+1OhByX9EEhkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720616619; x=1721221419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GWYvLutVvpNPgBageJj8H8A/uQDi1vyHTGEzq9IVLnI=;
        b=RBZ4cAESX2MTiRKihN+MC9+LNLbY1Od6qTxuKSFNms+4CIUuxcYn6Yk1dGv624/7mz
         wSVqIv2p33Un5KkJv4wvhM5DPSbJSN8Q/ddjnr3enIsfuobDvglLFPsrFP5rWEZcxSdL
         hijB2aBMU9B6pOs+0cQA5FgJrL8tZz6mO1rjs03PMLGYjPgefvrOTOG8vmcsoiB3NXdf
         Eb9k2seBminpuelU66z4FNZ7vcXdV1llTkub77EIO5VpPqWKWocBenDh/79GqzCjU76m
         ih78gx95rCk6FAlcdiwyGbQ4/ryXTE6XAU0xisedSLrw1RvCyBTy6pkMwcB8qmk6evxq
         h2rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWNGHa4hE2PjoKc8HUkTo+RbPOoW2kdyRVpRZaPc3YbPDP6aurjVbC4cC4HCyBs8vBwjip8MI6vk1ExVJy9iado3JJIgsBuFul4XjYQ70=
X-Gm-Message-State: AOJu0Yx2uFzs410yR11FYbUB2hzKO9TeLQwirxq6ONYEBgvIWUQvjsiP
	BBIdAjJqbwqAaUcQOUXuRhuKyNV8Xidz4gytpQ2+MAfvJgjA4ANrm83ZtDwGZF0=
X-Google-Smtp-Source: AGHT+IGMcjQoU+OYezjQTf52YHxfgUBSeAFV3/pCB994d1Y1agNCF9MxANmKp2bdSG8HgXlodZdyZQ==
X-Received: by 2002:a05:6000:4029:b0:35f:2f97:e890 with SMTP id ffacd0b85a97d-367ce5de46cmr3793723f8f.0.1720616619170;
        Wed, 10 Jul 2024 06:03:39 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cdfa07dasm5249869f8f.87.2024.07.10.06.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 06:03:38 -0700 (PDT)
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
Subject: [PATCH] bcachefs: no console_lock in bch2_print_string_as_lines
Date: Wed, 10 Jul 2024 15:03:35 +0200
Message-ID: <20240710130335.765885-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240710093120.732208-2-daniel.vetter@ffwll.ch>
References: <20240710093120.732208-2-daniel.vetter@ffwll.ch>
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

console_trylock is the best we can do here. But John pointed out on a
previous version that this is futile:

"Using the console lock here at all is wrong. The console lock does not
prevent other CPUs from calling printk() and inserting lines in between.

"There is no way to guarantee a contiguous ringbuffer block using
multiple printk() calls.

"The console_lock usage should be removed."

https://lore.kernel.org/lkml/87frsh33xp.fsf@jogness.linutronix.de/

Do that.

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
--
v2: Dont trylock, drop console_lock entirely
---
 fs/bcachefs/util.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index de331dec2a99..dc891563d502 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -8,7 +8,6 @@
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <linux/console.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/freezer.h>
@@ -261,7 +260,6 @@ void bch2_print_string_as_lines(const char *prefix, const char *lines)
 		return;
 	}
 
-	console_lock();
 	while (1) {
 		p = strchrnul(lines, '\n');
 		printk("%s%.*s\n", prefix, (int) (p - lines), lines);
@@ -269,7 +267,6 @@ void bch2_print_string_as_lines(const char *prefix, const char *lines)
 			break;
 		lines = p + 1;
 	}
-	console_unlock();
 }
 
 int bch2_save_backtrace(bch_stacktrace *stack, struct task_struct *task, unsigned skipnr,
-- 
2.45.2

