Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C034D1FC10C
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Feb 2025 08:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740298564; cv=none; b=Xi2yrlJifIkBcGoGJWuZJmm1WQULO2CNHnF8X8SBaLhQaNJNSs26cnmxyKKKz/SOHMnV6lSs+S/4JWx4cVK8tbiH6xhg7QbK39itlkPmpeyt1IEPg1LrVeukwIgktGHA3pumclWIDQkUADguT2d29Zyd/9kSSIxtuo3Zj829+m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740298564; c=relaxed/simple;
	bh=9Vgyp4UC7Lkr9EKXhmowcS/TtlCW/7Og9GYbYG5MWVo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GH7ZsabPxZwJ7wDFQUfCH1oKae5D2VK6fU70Dqeaxs0uQcPgbk3Myd7f4qq8q4EOD1gykW+VhU7LGjuE9JFn2RLLacNk52j+9jcmgy6luh8rlXnN59JPAUMbbsDGLId1hmYVLk4RndkSGWJMujblJnzMDCkMPmZg65M2zQ1cmF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d2b3a2f2d4so67751655ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 23 Feb 2025 00:16:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740298562; x=1740903362;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nQ+4otSDBeDUmexmVHW857ZJ5T8kJoJYo8BJC0cLT60=;
        b=G+Bx944C1XK5J+9dt/rYWsvr8BAk0OtF5HHQJPpAiATM+qHk0S2ZVuv+XVzzxvC0EW
         U8wZZjPMy0iS9vupudawwpPV3rFEGYbtifxKKEya/AH1fzLCJXFLeg3m2+iHRVP8J/pM
         qoMUb80fq045YQFefcMGlWt6F1cnyDmM2Joay/neI+cz5iXCrKh/W+s++nuuDFt7dnnV
         YINaPy8gRgPQilH7y+yr0gmXA2pI6T1r61m6Ks1LErf9qqgj04C46UE/6sH9YY4hs0mv
         jp4yqjea9+z3aGXcKSqM6xgvM8eonic183cTNZWsxtvNfOZp9UaIOt7cEmTnPgRKRN7M
         XkuQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8di+kG54MvL3LhbVv/Cbfpz/YNZr8dCnHmFaUw9DWED16wJsL4HbZKlLnLdqAprZI5tckpOulL21/Gc1c3Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMfYsPyylX/CWmLJ9SdWH45fqNy/VlMVB0CvlAoYaxGBgD+FzA
	CxyBDfWwmTKaA9K+eyZQhzXPAFnhBJD5cdkosljfvzUI+79S2njDkUmYhzRYgUHhR0o5s0EIsjb
	IqHwZFMvBp3eVb5wmyh5IEijwOzlfg//7LJnZ3NVVu1ivGds+jIAuj3Q=
X-Google-Smtp-Source: AGHT+IG56GWEOjnEyuPlcE5AZ8PYXTkhW4aFR3TLLN8zrCAQ7vapNIVlQKuln6iV14gMIqD3lUcgnKyzGkcfLVlFKN4Mcr/+ISqI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1706:b0:3d2:b6e0:79b4 with SMTP id
 e9e14a558f8ab-3d2cae6b5a4mr86784545ab.8.1740298561939; Sun, 23 Feb 2025
 00:16:01 -0800 (PST)
Date: Sun, 23 Feb 2025 00:16:01 -0800
In-Reply-To: <67b44ef3.050a0220.173698.004c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67bad941.050a0220.bbfd1.0011.GAE@google.com>
Subject: Re: [syzbot] [bcachefs] WARNING: locking bug in simple_recursive_removal
From: syzbot <syzbot+727c886b67040701c448@syzkaller.appspotmail.com>
To: dakr@kernel.org, gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 14152654805256d760315ec24e414363bfa19a06
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14dffae4580000
start commit:   2408a807bfc3 Merge tag 'vfs-6.14-rc4.fixes' of git://git.k..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16dffae4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=12dffae4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cc40dfe827ffb85
dashboard link: https://syzkaller.appspot.com/bug?extid=727c886b67040701c448
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17982498580000

Reported-by: syzbot+727c886b67040701c448@syzkaller.appspotmail.com
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
