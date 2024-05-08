Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7017557
	for <linux-bcachefs@vger.kernel.org>; Wed,  8 May 2024 04:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715144357; cv=none; b=cmtMsABOWkesZ7+z5vRkPax4wAeleTsghcFl0To1mZrQ5vz1cyXV6YplDiZJdOFjfTCNCfkwPojxDWDe1CiXRF5jVW4q7k5tdvj3lFGnyyro0pDjSg5wCAADvSndbDGBcse/6dfnjnOuIOo/d5GHsA+2UHl/65LGjk6MlxSW40o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715144357; c=relaxed/simple;
	bh=grguybPX+h2UCon/cjSOa+mzA0KlDjT4Z0Lej2+UKKs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=do3G996aMA3QWef+nVLs7KbF8ZzpAlUqlFt6VofWDBM76RpmBqqDs8vToo1MpwF6un7dVAAJjtcygI1sjxu4n8nXhh12Xo9hx+bdKMUeSNUvQIk17DMb4Ockoqhun5LdTS52nAMP9c/6pIMNUeZ+cT4OILzlFSnIXj3tYTqEDBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7dee502fae6so447844639f.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 07 May 2024 21:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715144344; x=1715749144;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/+fjCTSoU5FfUWAA20oSxRWPOgaxuApk8TbKtRkB800=;
        b=SaJD3kCQM9LY38blQtPIBdd9qSs2z8BDbqhfnFIvS0f2KvkDm6YW5gB1pGNc0huKAL
         VDaiAQQ+ySVLTki4buHc0XjR35UuzMbA2T7jPjB6vcPnI0Sa+le0tcXLpAf/lTuzHuew
         Bvc2l63iOiLIwPmrLwNx0vhmjT8y1blKZoz+XFSl1/EuxcpROzghh7JE/N+ypOIkWX2h
         ye0eaMYCXlDunNWI5nAaGXuKamBnDE7y1IRnGUEQAAt9ly3GAb5BeNJnAmHPk+SbwjN2
         zjJYzzN0yke1YW+5wmnqVzW7ZsbE/Qvne9N4bgcdPKfvpkdy+I/aSpDTzzR1ZW7sms1q
         m71Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEkJ9mMYXUFqbbxNDjp559b9Gh7Qx7xGyprNwnmRv6AYoK3ta64CshxD2aASoTE/wcwYAd6rmfUIn6pdTApaV17IYI69olc+7jcMZYa48=
X-Gm-Message-State: AOJu0Yyz7+uv4Z12//mxBqowWB8ecus+4F9jmY9I1S9oPApfQOrfjLRr
	aQgJOihgBzcwGPbBF5wKMi88MwzyLnhaiITwB5zYRPqL1yxwREIUQPbQ/HJlRkEuwbVa3oJxvUS
	90G1SZbhOtQs89BNKodiMujepl4p5NGN5BE77oaRdSK9HrX45IkLQBrw=
X-Google-Smtp-Source: AGHT+IEvpfUKYLFR6Yt0QR5x4KvFKT/3f/v/oGP7ub1t1z3lYGWgIabF/NIxLsvTG2D6jXzDlmXD9R+tRGTWmddwCniMs6ACFlAW
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2194:b0:36b:3b10:7425 with SMTP id
 e9e14a558f8ab-36caedba2cbmr263145ab.6.1715144344615; Tue, 07 May 2024
 21:59:04 -0700 (PDT)
Date: Tue, 07 May 2024 21:59:04 -0700
In-Reply-To: <0000000000008160ad06179354a2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006650ea0617ea29e9@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_fs_recovery
From: syzbot <syzbot+05c1843ef85da9e52042@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14fdf9a8980000
start commit:   ddb4c3f25b7b Merge tag 'for-linus-6.9a-rc7-tag' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16fdf9a8980000
console output: https://syzkaller.appspot.com/x/log.txt?x=12fdf9a8980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=05c1843ef85da9e52042
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1464ea2f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130db31f180000

Reported-by: syzbot+05c1843ef85da9e52042@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
