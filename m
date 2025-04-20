Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04501F50F
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Apr 2025 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745183525; cv=none; b=renjF0Nnr9vVgYl/oa57Yo7K6nIjM4uGIU46IRbmk6yGixmh7wpHHJiNAKp5xrNH9wE3M7M+4zZAhU0pc4k6/n5gowrCU9YF+5N7AuMNM3q8v9LKcip2hVYkzgsptI3d2CUuSOPaZfICU9NzK2YfJTlaasgl+IoU3Lcjel/Rz/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745183525; c=relaxed/simple;
	bh=Oy7p0SvJVxWWBdWFXxaoejLgcwVs0CiPvUYylgN4b/s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tiBgmlxDMgTnSrV1ofvZTQaQ+ErOi44r9E2b0cmt9hqv9HuZm01zYenebyOb9PmDzvuLb+GTP30GG1ZEZmTqdQ8HLh2HPi3+dr3bDmMWTnsqJc2gtTRFZjZhC08CtSkX4BKIgBPS5DffAXs1bPJYgE9TQxWcyBYcZzZP8txNbi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d81a0224e7so66644615ab.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Apr 2025 14:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745183523; x=1745788323;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Boq0bHHkT/TbtNYDBfgrkhUfQSJrgaxu+wkx0giGmz8=;
        b=iVLUE4bEfRnaw9GtZqwBpEJyS+thzI7ZAtgL5mDLuLmCaau5/TAaJ8l5aKZV7Vwe+O
         UgB9AanOlnnVXULQIDmQ8yioja4R+VAnVh/EQeGIA9SsinV2v/jTWGKGfP4Vi3gVSHlg
         ztmT+FLba9PKH8lc/+VytF20wURpYYI8p2CJjBCkFbOchUtDg1zQgck2uzvcEvDLoW7R
         Q8qIe5/c/uyD9Cxu7JTmb4YmfXKzcEf11WvS9pd6Yirky78E7DRKSerRK6xvkP8QWHzp
         42tfsTtW3P+Gn0wv35Ov92QmvyH1m+CGEpNLeosWBDTIxt9BLRH0H3I3OU6sBvLgMbTP
         SQhA==
X-Forwarded-Encrypted: i=1; AJvYcCUMMnfxyRC70EzZkoZpTctCC4iD5Rp7a3BIVB42YTGrMuD3ol2QL10jwbheJupQN2YHBK5f3f+gmzMrbAdQHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWrIHOVSZPNrtDzb7+p3owD8NrAbLzNkY3/jjyFUmDmGsmxEdW
	uDDStaKXL9BtWCl+YF9+sLySMvyBw0OaxJKiLqXEb6gH6TX/bjzOv6sXhsua3w7kTfHOZ6t9z1K
	+WGIXxSUJfpcOrNcwnk3QDSNvvazrmJIYYpBtiuon5vNWRN3ht7gKdiM=
X-Google-Smtp-Source: AGHT+IF/Q0jeoIU2yFclqVgUPetb93xeYLEU8M2AtbZSVWEoNFaSOCCmRbLLRrtMtx5NOXf5MGHLZ0gkeRaYuH3/Hgy8JvbcvQXm
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2189:b0:3d4:2409:ce6 with SMTP id
 e9e14a558f8ab-3d88ed7c3e6mr100403115ab.5.1745183523234; Sun, 20 Apr 2025
 14:12:03 -0700 (PDT)
Date: Sun, 20 Apr 2025 14:12:03 -0700
In-Reply-To: <674db1c7.050a0220.ad585.0051.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68056323.050a0220.243d89.0036.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in vfs_unlink (5)
From: syzbot <syzbot+6983c03a6a28616e362f@syzkaller.appspotmail.com>
To: Yuezhang.Mo@sony.com, andy.wu@sony.com, bp@alien8.de, brauner@kernel.org, 
	dave.hansen@linux.intel.com, hpa@zytor.com, jack@suse.cz, 
	kent.overstreet@linux.dev, linkinjeon@kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, sj1557.seo@samsung.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, 
	wataru.aoyama@sony.com, x86@kernel.org, yuezhang.mo@sony.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit b0522303f67255926b946aa66885a0104d1b2980
Author: Yuezhang Mo <Yuezhang.Mo@sony.com>
Date:   Mon Mar 17 02:53:10 2025 +0000

    exfat: fix the infinite loop in exfat_find_last_cluster()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=155b4c70580000
start commit:   bb2281fb05e5 Merge tag 'x86_microcode_for_v6.14_rc6' of gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=523d3ff8e053340a
dashboard link: https://syzkaller.appspot.com/bug?extid=6983c03a6a28616e362f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12cf7078580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10197da8580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: exfat: fix the infinite loop in exfat_find_last_cluster()

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
