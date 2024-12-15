Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0959450
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Dec 2024 02:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734228484; cv=none; b=NS/CcWnNomCg/SOKv7qAls7eTIXVIhULwZCPOQvCX1nP1G0dwQ8/DlDfRrx+qx74RS8+NEjHMmUv1lbIs/4/AQWcXOFszL4Im6QaPkPMFn2cj0ZbZ+q4rzJRJ+7vuv/C929N4EQx2kE0T/ON1ETN2Zg91W4A4Z/GTA5PAe1fGtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734228484; c=relaxed/simple;
	bh=6qdMR42hVUJF4DV+QEwMMQwa34hqKIvQBSpxMS5k354=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=fhVJcLisLFF13RYTn9pPXDSMLRvUcRzh4uANh4n/1a/h4t/eBHVpqn1IeE3c9l1S84i/GJ/YHX06OPneiMy3snYIxpuRHAHeNbwJKyQzYiCqcziErVfcKon0an4GhYVdrJ82G9itz5Ezq2g05lojay5GI9ZaQjeO0L8mpvL6pvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a81754abb7so57673785ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 14 Dec 2024 18:08:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734228482; x=1734833282;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VVd9QRa3RSnLpDuiGhYrNBGak9a7U/Tb19aR7sZOG30=;
        b=idzHCE60zonvBtvWd9ZJkqWdPDe/Ry15h2Z9MAUnTmbOgDzIYb9P5ueunStvYk8h+J
         ppqAEY3sEBz+yrdzcyaipM6nWqrLIEpA3PXleLYugEAAZHoYl+d9mKro6ldLTSrgNSoX
         u8FlbmmAKKqbv6TM+fEIQf40SXA26YBn2GB+ynSKmNinpjwnaSkriauHXqxi7ShNfEmB
         4QP9eRkDV1KyLXQNn362Q37jxHhEHmOtWvkMNC7Lo6SfwNi5NhKNXuhhNpkMF0QQi5dP
         upJU6Y4YvekcQ/XAkDu1bja1u8pYFLMHvy0emC2u90k0epivPTRo6hMeQWPfN3DTom3P
         5i2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXdl2Z6sQLLsH7a6l2m32PbHaBvd1oiZXMONXqoPQ6FT8RA1xKfBJrC/8/y3iQyy4J/t81L+wpjP8vpeBcEWg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4wEMf5wX5VgClOveABX5YQneakQGlyJFN4ZN6XvstWWifgE+S
	GIdRVBImhY3ISbUxzA/EaQ5hI4JE2dCGaj0nGs1qntokBfMELVhq+n0++7AIZXy2SWkSXBGuwxW
	f+p+ynV2gkT3wfyB/vCctT+VbjIUngyTPoxLvJ4FVif4lLJggCy2tMWE=
X-Google-Smtp-Source: AGHT+IEAezhzXIjYYJ6ypzh91V89nljSboeSTN+syCQMHBb/7tdQEwRGb9luGwsWv0doTG993TD+phZw6J2KJN/iaRs+NUKr7TeI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:168e:b0:3a7:81a4:a54d with SMTP id
 e9e14a558f8ab-3aff1118613mr103484095ab.20.1734228482639; Sat, 14 Dec 2024
 18:08:02 -0800 (PST)
Date: Sat, 14 Dec 2024 18:08:02 -0800
In-Reply-To: <6731d0cf.050a0220.138bd5.0063.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675e3a02.050a0220.37aaf.00e3.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] general protection fault in six_lock_ip_waiter
From: syzbot <syzbot+13b85e45ca365499aad5@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15d46730580000
start commit:   243f750a2df0 Merge tag 'gpio-fixes-for-v6.13-rc3' of git:/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17d46730580000
console output: https://syzkaller.appspot.com/x/log.txt?x=13d46730580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c7c9f223bfe8924e
dashboard link: https://syzkaller.appspot.com/bug?extid=13b85e45ca365499aad5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17312730580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f4bbe8580000

Reported-by: syzbot+13b85e45ca365499aad5@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
