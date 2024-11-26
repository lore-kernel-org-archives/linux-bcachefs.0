Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE191D7E4A
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Nov 2024 16:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732637886; cv=none; b=tYqaJwG2rwl8k2u0BQV9bZsqnZHxGZ9UxGmtGr14yuwGIo7ahuLReAoQQw3KUt5v3P0GlTlwdssw9pAafplf+ucIEeYyzytnhzQNCKGxczS7tUSDMBBdvpUU8gIeg/G+gBSa+vpGKwLW3I8mi34nd2AGIBXcSREAxIZaPLfZ75Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732637886; c=relaxed/simple;
	bh=Iw0pStb8CZ0fodCHaPZSSu7jsxSq4pCU5i/mh2nn67Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=awsx1f5xh9jGxF7+Jgo6GQBDO+QV1hoAVe+3pWYhw9jnBj5itpgHlG/UtgzYinnap95M6ymjQIDMUj6LKLMZAwoUJL9NC/t/DR6lQjEjM46vhiREEA7RFOzHo4ugvZfSDBJ0A7L7QeZrbyOwvhcbYHXfiQAZFT7ttTRQ0PU+Ujc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a7bdd00353so10944165ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Nov 2024 08:18:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732637884; x=1733242684;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a9DtD0qT+Ay2BiKx99/pByg5tz0NTNu2+EHpUxVhJXs=;
        b=CRLUFHzTMpf74iCFSV6+NZgg7NxSCW7nkUj7nBEEmKj8wI0bwUEJ9L6N3ogHZR8Ng/
         669vdUzHIFkR9bdGP7c6Xz2LqsQ0SypnEN8wJPOnA8G4Nwj5PpdUlPyd44pWxTEqjHSg
         neQM2JaZsJM+Z6y3SUvjLH2CFXiFbeHvkTZKQ/Stf1UwyLjnEBpv86nNIt5bq8urNvhZ
         bKkZzBmCZOscvE0cD1idZyyp9wP3DibqRR0NKF71VcbCVyf791IskLEC9k2k7l7+CnSZ
         DAvUWkJgzHUiGG81w9PmTI9smJKlPbbRTGrUM2BsJJNXn6AvduEkrkDq0hDwC4cTfcfK
         ij4Q==
X-Forwarded-Encrypted: i=1; AJvYcCX4RkG9ZqHNAxn/Qdmagax+UYPTikNfFTBVppIFDNZ/LFXSaQXS7jb9jegwtm1BDjB9J09IpgAqElN6AXJ2tg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKnKLD0nvTMTfW9YO5k0vZKHFAKUkoEtFTFykatOvb+bAWyGUA
	1lng2DSRKvZF+MhLq7ii+k06Utu6YDeLNO0RVjbmiRmewLSr4Rnk0C8va42MFmKjzfA8t0neVRB
	jWarXc+j0nLZRwV7pfcpOK5S+wbSTfjFQZ+NKGIgajDYVBLqgobsUqdc=
X-Google-Smtp-Source: AGHT+IHn3qG5Q2sQL2/n/zUWg0mqXswtHHhQeWx8CuAUi6O8y5a2DZRSJ1MCAhMb4y0ImekB+ahZKaGalSLMoepjPxuzUvcW+HkH
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190a:b0:3a7:93af:ef55 with SMTP id
 e9e14a558f8ab-3a79ae9d90fmr201107455ab.12.1732637884357; Tue, 26 Nov 2024
 08:18:04 -0800 (PST)
Date: Tue, 26 Nov 2024 08:18:04 -0800
In-Reply-To: <67447b76.050a0220.1cc393.0087.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6745f4bc.050a0220.21d33d.001c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_journal_pin_set
From: syzbot <syzbot+3bd0834534ada7200422@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 86d46471d52bf33e8652b220741d3223338d1724
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed May 29 21:54:46 2024 +0000

    bcachefs: Don't block journal when finishing check_allocations()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17538f5f980000
start commit:   9f16d5e6f220 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14d38f5f980000
console output: https://syzkaller.appspot.com/x/log.txt?x=10d38f5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e92fc420ca55fe33
dashboard link: https://syzkaller.appspot.com/bug?extid=3bd0834534ada7200422
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162325c0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112325c0580000

Reported-by: syzbot+3bd0834534ada7200422@syzkaller.appspotmail.com
Fixes: 86d46471d52b ("bcachefs: Don't block journal when finishing check_allocations()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
