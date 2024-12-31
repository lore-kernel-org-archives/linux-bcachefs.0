Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E364217548
	for <linux-bcachefs@vger.kernel.org>; Tue, 31 Dec 2024 14:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735654027; cv=none; b=BUXC+57JcX1OV2efDYIJbKXoQ/CirshIm5opY1dwRgTHihJk8VmhgORiU9D3S9vX7LSo6YtbpTlc3xfcg5FYXVPFwZW0856KjUWpwdA+szy2HMBZv52kbVkb0efZhO8N8Nc+8Uar+mmoWQQVLbEr5S6Zjh9/EwiScJDv92c+Uwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735654027; c=relaxed/simple;
	bh=z8FCMlkUPR+5yt9n0horofIew3HL4NER3rUlBwYOQ5o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=sc0e2+JFoIaXKTP3zzH0ffxOt0W5tcB20UkOqZRgF2QD20+Z/0HYIy/YljXJ6yLx6SeJInGXNVDJVfHgehpqA7ulHy0CEjWf88lZUfcuRgmP8l7gyc5hQjVX9AJxPj5O54flZpBJgok3ZyWT9qhSZ+A98l2gRddqCJdhvUxrzyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-845dee04284so769539639f.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 31 Dec 2024 06:07:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735654024; x=1736258824;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aVxDOyqAwDO+fi9G6Z0mEodtMK4Grf/gTGIRTp+5zXM=;
        b=NVwq/EBgr4eEY0JbXVG0M3pWthE86jIDsXiMYYQTrRhi1/W/U/8WAcGQ1MJbgZTFEe
         dqZ//NamdDxN6JcOjcIG42L+FvIB4aS8jvHh5YQAStDnH4EJtAozhG/U6U5ddV4XCe3t
         3a0lndkbc1sS5K+F9ehR+MLS/t1FZRr45T6sLkMIAi8tUhjoxOcBuvJNwLW2yLOxQ8J0
         bUFd18DVn6ebr0JgiZLVrKwHTFaju1MIAVkhZ5P0U+HXZwTJ/GLJ6nug+Bs45dhGlz5l
         CvQvmTRg9YfrjWmzz41k1ZDVSv3AT1bzw2hAltJw6GBpANuHz8MbBZCYiy9Jp9QqWEQ2
         hHOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWxuCnh2IVTNw8hmyiGAfIg7wWdITyhkZbo8b9hr2poi+07VKXpl2kbatndtk3Q4VwNYaSuswBggUmy3rzYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJYQaUfPzovqvKfw+GscKyyRktcDH9RwAZKr0SFGefnZj/NSz5
	KU+F10HlFcHepEKonUfQBlpWhmbdHnd+Ac33fh3eKkGl8dMosBJ+OluuN8hhrmnb2tSeLNqn3FO
	49C44OwlHu65s8Db2BXssMa9XFGdPOfhjlxU1nIiN6l94LqwBfios1E8=
X-Google-Smtp-Source: AGHT+IFNMs8Uoh8jQYXmtGeYza9i32sY3np9FaOk332+Ihcszo0mps8EgDxnleA5UBVXmMdupdDpHTmP9e6b+w9H+2rUj9vEJgVG
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3891:b0:3a8:1195:f216 with SMTP id
 e9e14a558f8ab-3c2d25770a4mr326179795ab.10.1735654024008; Tue, 31 Dec 2024
 06:07:04 -0800 (PST)
Date: Tue, 31 Dec 2024 06:07:03 -0800
In-Reply-To: <6772228e.050a0220.2f3838.04b8.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6773fa87.050a0220.2f3838.04e4.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_stripe_validate
From: syzbot <syzbot+f57d864a5d6eff90da3b@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1644bac4580000
start commit:   ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1544bac4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1144bac4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba7cde9482d6bb6
dashboard link: https://syzkaller.appspot.com/bug?extid=f57d864a5d6eff90da3b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=131666df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10556ac4580000

Reported-by: syzbot+f57d864a5d6eff90da3b@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
