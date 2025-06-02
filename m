Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA12BC8CE
	for <linux-bcachefs@vger.kernel.org>; Mon,  2 Jun 2025 13:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748869329; cv=none; b=Q5+2moyXdjytOl3eH2CN+iHm3r5xme/CbjviIKbQd3MwKMy4J70qRpMlEdKqSbsW/l7ZX0ZNLGOUqlWfLuDJrm+LUVTtYwFYNqqclataSDeyZAX8vk6Qe5Pcs6nl3XQni4+r9kK1DG/S+XCtTDRIo0xFKia6CQF5ibOk4hwV0X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748869329; c=relaxed/simple;
	bh=TtkT46dVySzqpj34qqQIaU3JLj45FXDa0CAJbYjQ1zc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=rqXBCYren4jINYAXyMUHXKc4KbqICm7wxVzmlBOAj9NmyDPX5NnyccrEXzVor5/a+kTUMeo9pQTp7gFtFx5xsSqIHhxVX/TNOawLExWkAbaHO9hGBQK6zrpd2NJ9ugwUDnbBjwwujBZ4qo/BmG63K9XU9HoRnLnmWxGm2hpzCHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3dc9c1970daso41597185ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 02 Jun 2025 06:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748869327; x=1749474127;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7fxteB/f5sDtYeR1EMo4Ak0z4+Q25y3p1Fc+NOwwIY=;
        b=i2NV5NeMb9HmBGrKiG3txNV8iIq8ovvdoOtBpofmPn7VZL6mZ0SsuNlR6iiLIvuxLA
         ZjBEYVTkFAc/f4S+ZpNutSTkFf4xxIytIUFA9L51LfO52fEfSo6vWwnF1NvFkcAS+KIx
         wXu16yBS6b/TklB8Fb+oOzoYhmsxMbtZhD8HT1gZLoQIVlK/0xyh460pYFplWEjDn1tj
         lR3XwUTq5D5xYIDxsTfsOWvE6EY6PIYMtWs66JvH2IMpR8AjTchgCTQ8gExflmbIHXk1
         SF+4nYGcq1h1kY5R7OMnTlPMZzSBe+mJm+twDDayD3MoXtjwNPyfdOkKx9ZyXSWNCPE5
         joNg==
X-Forwarded-Encrypted: i=1; AJvYcCUfE4fRWNagRAU4V/g1M0SY48+Wa29GDlKa+HAlwvZt+VZ3j4b0reaFf30ao8Mh+I1g8GMBHJkoMBc8+rjPGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPGZXl9DV5DpUesBaw0B9QH4FkH1PTlNtxf93z+CDL0lzp/WPt
	o6Az+dpmLGAtc+lg7MshOB8hSjfOeFaeVGb35cPz5stlqxslXTumKmgJ8tyTXRMlYFCJ9KntfTh
	RMLGt7fen5GOHHOmLeGgqEQUkCkLdECmaC8A2Xz1FtxtrZ0Pf5H7+TTWvoxQ=
X-Google-Smtp-Source: AGHT+IFWtTdvixuVzBD0tn2upCe8Es69ApyF4PTbdgFaEHRZJy+E6cBgwD65KLDcZ2xxw/V33d/AHZi98X2kLR8f3KcI+qbaKPu3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:5e0e:b0:3dd:b540:b795 with SMTP id
 e9e14a558f8ab-3ddb540b9d8mr3170435ab.3.1748869322784; Mon, 02 Jun 2025
 06:02:02 -0700 (PDT)
Date: Mon, 02 Jun 2025 06:02:02 -0700
In-Reply-To: <683447f8.a70a0220.29d4a0.0803.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <683da0ca.a00a0220.d8eae.0051.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in start_poll_synchronize_rcu_expedited
From: syzbot <syzbot+cbc79a37b5fa23efd23b@syzkaller.appspotmail.com>
To: agordeev@linux.ibm.com, boqun.feng@gmail.com, guoweikang.kernel@gmail.com, 
	hdanton@sina.com, kent.overstreet@linux.dev, kpsingh@kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	paulmck@kernel.org, pmladek@suse.com, rppt@kernel.org, rrangel@chromium.org, 
	syzkaller-bugs@googlegroups.com, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 82067c916994dd1bfec65496144dc16e17899e36
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri May 9 03:21:28 2025 +0000

    bcachefs: buckets_in_flight on stack

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12fc7970580000
start commit:   3a83b350b5be Add linux-next specific files for 20250530
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11fc7970580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16fc7970580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28859360c84ac63d
dashboard link: https://syzkaller.appspot.com/bug?extid=cbc79a37b5fa23efd23b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=106ebed4580000

Reported-by: syzbot+cbc79a37b5fa23efd23b@syzkaller.appspotmail.com
Fixes: 82067c916994 ("bcachefs: buckets_in_flight on stack")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
