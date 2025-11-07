Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397DB27F4E7
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Nov 2025 00:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762476606; cv=none; b=u7qZO5/IXnPMk2f+z8H4EhbDfSBLS8cbkRW4DEMZsVHqMm2cb8T7zE+ObdckJVU9p292Tsvy/QA3yF5t//u/4ICmiq+WDBPoHHIcli1UFKOAskMP5c6L9HoL14/JZkWro2NKeCpScdVxTfySMqlNXB0z5HhZKy15OxWDOvwIoh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762476606; c=relaxed/simple;
	bh=/uGxiUpVwBCUN3pD95xApGVngYUG2y+wBWn2neOR9RA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=meQibdGjfm4xdOCyhWfx5dOaHodcAA7O3G4OhT95rS+vnlmbyKMlxQLzcTM+iy9MqaJ5owiv36AiB+tMa3tLJkR+Yi6wb+NU7qQp4Yn52PlRjpHZXPW0z1QheBHix7YCwozILbiaH+eD9kP1SU8wwQA71wlF7Rj8flAzUzoq1WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-433154d39abso8647155ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Nov 2025 16:50:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762476603; x=1763081403;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=scf9HvGkj6h9nQoDt/eHw462ipN6/I7qKBtgiEBj0/Q=;
        b=UgW2J40DYhR9UslsciwbUEkI+17lxGqD71uASsIPLVZgdje8m7OLHx/b+3xMQFbYy7
         pDEE37ZhYrRFwKlp55CWnKaQ7Pk6j6NHP1sF3DBEyPjZso/WXq+Rl/4zJ3OsbopiGZXC
         pPUfZTVxcmZjCO9Y5gWQsAp7j7Gnmdd3gZX6LCXDbpK7pvvFAB3JZ9lhyDTVMcPO8s8q
         3rzv4XF+w0QfQ0yrFnexpbjdBzmC/q95SgSW6tnl5z9MHZ0rdQb3w8Ms3OYa78Sg/rAU
         Y8J67cpwXbwmNZT199SSHuiduWKRhbWTgP+wMtfiLm/iSpxnsiKX+AnRz+GYT80Nd217
         vcqw==
X-Forwarded-Encrypted: i=1; AJvYcCVnckhVw++0DQAOiQ77TTc+ttwSxYk2m4chflnxLaYa7yG7wfvQNV8AjIOaP23t8Vo2GLLwqbe9Wx3bp7FaTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWLMxfKgYdiTICNjrRl/4rC4kFbvQtkF2CxmdNT/OCdOTJV0VX
	vkdfHWpIgZLlPC4Zzf5yG6bEaGAzAkxG2EnA8HCciiH57bFoYkFwF2dfuUeBuj3hXi8pLJdYUXh
	k3a4168elhTHFXN9Go/fT6COy4lIQiaLGNPotEGm0b9ZVSY59DEaS59E6eHA=
X-Google-Smtp-Source: AGHT+IHnFCEBkoL4JIf5R7Srt0Ir4FqM6VEIhsdO/2foJ1skJV7nN5HJ7sGRku8OoXDZDqtYlhQ4ivlCIsxA9YPSXakQPDFPPEjF
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c1:b0:433:1e74:9a52 with SMTP id
 e9e14a558f8ab-4335f53dd2dmr23233735ab.15.1762476603127; Thu, 06 Nov 2025
 16:50:03 -0800 (PST)
Date: Thu, 06 Nov 2025 16:50:03 -0800
In-Reply-To: <68dad4bb.a70a0220.10c4b.0086.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690d423b.a70a0220.22f260.0012.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in bch2_btree_node_read_done
From: syzbot <syzbot+ba71155d3eacc8f42477@syzkaller.appspotmail.com>
To: eadavis@qq.com, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lkp@intel.com, oe-kbuild-all@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17012a58580000
start commit:   083fc6d7fa0d Merge tag 'sched-urgent-2025-09-26' of git://..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5b21423ca3f0a96
dashboard link: https://syzkaller.appspot.com/bug?extid=ba71155d3eacc8f42477
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16433d34580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e79f12580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
