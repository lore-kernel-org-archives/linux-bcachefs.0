Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D817174F
	for <linux-bcachefs@vger.kernel.org>; Sun,  5 May 2024 20:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942745; cv=none; b=cAcr6B8RzJkFDNFYj+ZxLQG1v+ofQG5aSyuq3ElgKSaHltOKD7T2QQarzz6B8wrJafvUc60g2mU33SDeAa9fe1SlEwoYsb2M4sDgWibTFPKfnfpfVQe3Cwj1j5qPIXSMNAaDAvTddFH7qmAYZCnPi1ppj3/Xgey6HArp1rBEZyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942745; c=relaxed/simple;
	bh=MuUD9FFWuXSGLaTNUDVSvdvJhbVmlVaZRI2izi/lgkw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=m7rSUKECiEUaKubOs4t9dMS1yA81ULf4ozto6DdIbVP3dEJtECneB7VBUk0xV6nWum/KOGAhl9wASVyzNTsAf+nbUvC4zF/C3gify0KlDuVdPBPcowRXVtRizfhag9ocWznWfHxbLcyO7N5m6WyOSC3g8ypyjpDCSu7u07gBlPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7dee48ec44dso153275239f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 May 2024 13:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714942743; x=1715547543;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3XZzzFIOk0q1XGbjNkVkwmB0Rx4sKexxyAZqWMu5IjM=;
        b=RUd/fY39S56S0MRz4KiaZOexajkBpeAqD0QshXA5Il+aBlqkuckginpRtZXm3obhyX
         QTRgubxNzOtQMuCDa7prbHqAHzCBy+GXFBqfUkr56ifY5jZqRyHdHD+fRn7s63vXjkwq
         A5uJc+mav0MuY8JaEnlIn5TCntRyf0Ow2vWlmnmNuYK7PUuuWKMMRg/xx6mVQ/T+lJWs
         /6A+FSlk7UIAM65fM+3VXUFh8zcmtCGFV/BUxyAWplzeOfTiUsHw6IlmA7+0ZPPdU62Z
         SPrj1q4pLMjjg0D9jQSHNqO19tTiYGJQKOC9HjKOdAqwPbzpUV6+z9zBrnPmUNP0jlvy
         uVYA==
X-Forwarded-Encrypted: i=1; AJvYcCVDyy3yFAfzA4TdzH1PD398+W4sBxrEZSCsk7fmSq60x4+tIJUq9X60EXUkWETr/vX+gRTfayXgd1uL9oo6Sc35EgcZIibWw+BAXGjP8yU=
X-Gm-Message-State: AOJu0YxqhvQ/LviWBiQubVRw2rIwPODglPOJdCvATOTPZpT3nAUwQ9Qo
	UK/cpUtcEHXgVGTjrpCWBP1nBwV1/BYgYq2axbHqWxB/QRIjR+gBO3iN1j38sV710qzNJk3kJmX
	lTPWMaLeEntBCpRV4jbi8Le8HyCdSxByZoSTh/EiiAZrgs4+Ni7oS2qc=
X-Google-Smtp-Source: AGHT+IHlVd3hJWK1UWMadrAPWJdyK/1JHLko1J5M/PynvAhDREjCeIBwi8faa/qySXdPgKHzRQ2YidiOAMaHKEotNz/OdZlTi0Ry
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8c18:b0:487:5aca:1a49 with SMTP id
 jl24-20020a0566388c1800b004875aca1a49mr344230jab.1.1714942743591; Sun, 05 May
 2024 13:59:03 -0700 (PDT)
Date: Sun, 05 May 2024 13:59:03 -0700
In-Reply-To: <000000000000897f760617b91491@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000ac63c0617bb390b@google.com>
Subject: Re: [syzbot] [bcachefs?] [ext4?] WARNING: suspicious RCU usage in bch2_fs_quota_read
From: syzbot <syzbot+a3a9a61224ed3b7f0010@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16f8862f180000
start commit:   7367539ad4b0 Merge tag 'cxl-fixes-6.9-rc7' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15f8862f180000
console output: https://syzkaller.appspot.com/x/log.txt?x=11f8862f180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=a3a9a61224ed3b7f0010
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12376338980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16047450980000

Reported-by: syzbot+a3a9a61224ed3b7f0010@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
