Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7863B175D29
	for <linux-bcachefs@vger.kernel.org>; Sat,  2 Nov 2024 11:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730548627; cv=none; b=XlxaOZYeqYtt4s+yGOwhEr2qdqAJh4wFIl+zzSS6wlb6G43yUVadEB2RrOe/zJ8Q8zros0ChkQUkFlFZUG9mG7llACswd3e9L7SLoOEEZVQSvjAuGTKdH0pcy39nqQl17wEe7Lu3FUT8YfwmFsTRbyyNJ9k9NpXuCrM9S96HkS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730548627; c=relaxed/simple;
	bh=hY7Qp0LVBzkxDGAGCzMbU3IbUplH3cDlFNADtweXEZc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Pm/BSGi/q7W9ImbWr9bmJiQUWVzkzt5YZvM8RrutOn9LWqGIjLAGfhkYAFrWYIxw0rd5PqPkXhTW/DcMwDyR44ljeW8fqlzbXoxxNO4XMkYnZIYU68Dp4zdn1GZzgfjf5vQ8gHLDyOciXr5nw4mfahIsJ/ouRa48rr5CDMEuTzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3b9c5bcd8so26287785ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 02 Nov 2024 04:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730548625; x=1731153425;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HQgRivpVF9UQ7N/9UZp37aX+ZdPtlXZX6nCsGrsrK7A=;
        b=dIduMlU4cfyjPyYSdOpTs1KhSib3E+KmX3X9a5PlLcLNnnpyrwwfXuELwzLDetNo5j
         CqeClobw2jxzBg3fgMSGUR0KKpeKlE4QSPpDjEZU/xKSVPZ4Y9XMLwrCI+Ui1oMLKYE6
         iLqzPw36R7IYpGs8QuzuLj1yV9SWQZjP6erD6rC8cpH5O/+idGTu4Y1wG5sIEOMSuLPR
         qap0Ts4+nTVy1dgbK3kPr9sLxOgd+84TGHVgBPFGMBkiGOwElIEnxpco9DccPuEThwdj
         QUw51JoDK3eaKhQxyGaU2vWeqOZYuUwk0gzBtLL+qRPdaIV4XP134kdGbN2LtsS49zVg
         wyww==
X-Forwarded-Encrypted: i=1; AJvYcCWZ4djUwnOGe+PNvR/DKy4CBGKxqxn3WJlzvuEiF73UanQT8jAoFnCWd7EuVYD7SPHf3SnP9EZgCp3T92aUNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyFWRcmuJQbH/af9bwFF5zSZD4EH+6eCea4kzDoZ0aeMyoeEWv
	zs7Gi8+ES9yJOywVMv4YGTmociC+Z4633NM5EttWsqoLivCQrlhwlqJ2LSF7A/5Wn1SgXcGMa/a
	1gpC1hEYc8eJYnuy3fZDn0HIHRteDH6q3bEuwosyPRaMVSSmNDek6XtY=
X-Google-Smtp-Source: AGHT+IFmFNjiUlFoZ19V4DOoAQ7Yfyn3jBQxK76YJvFOFc/MWy6VS9PygxeZAEgcCOGek4QuT953M5xXCWp1GzRzKm+B7wTJlhH1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fcc:b0:3a0:49da:8f6d with SMTP id
 e9e14a558f8ab-3a4ed3057c0mr239739905ab.22.1730548624722; Sat, 02 Nov 2024
 04:57:04 -0700 (PDT)
Date: Sat, 02 Nov 2024 04:57:04 -0700
In-Reply-To: <6716521c.050a0220.1e4b4d.005a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67261390.050a0220.3c8d68.0976.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_dev_btree_bitmap_mark
From: syzbot <syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com>
To: anupnewsmail@gmail.com, bfoster@redhat.com, devnull@kernel.org, 
	john@stoffel.org, kent.overstreet@linux.dev, lihongbo22@huawei.com, 
	linux-bcachefs@vger.kernel.org, 
	linux-kernel-mentees@lists.linuxfoundation.org, linux-kernel@vger.kernel.org, 
	manas18244@iiitd.ac.in, skhan@linuxfoundation.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 60f2b1bcf519416dbffee219132aa949d0c39d0e
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Apr 16 23:33:51 2024 +0000

    bcachefs: Add asserts to bch2_dev_btree_bitmap_marked_sectors()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d4cb40580000
start commit:   6c52d4da1c74 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1034cb40580000
console output: https://syzkaller.appspot.com/x/log.txt?x=17d4cb40580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f527353e21e067e8
dashboard link: https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e972a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ead340580000

Reported-by: syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
Fixes: 60f2b1bcf519 ("bcachefs: Add asserts to bch2_dev_btree_bitmap_marked_sectors()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
