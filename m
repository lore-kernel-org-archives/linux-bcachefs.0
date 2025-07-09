Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BE02264B0
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Jul 2025 19:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752089645; cv=none; b=MkLJCAKCHPezMTjWO4ni0oZOF/HqqZgk4cXaeBxcLbTrdFgZvTtLkWSGSIHYcE2g6MgPIqe8YsvHf+hvJvWDzZhmkPkadeCV3X3/OLDWMpPxeJXEV54XAv2RLm4O77sw3CccwYimTEXb1JUirqZ4yrqsHn3Eeucn/wcvKICg53Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752089645; c=relaxed/simple;
	bh=FmSWEMiKS2GWteM3+xkqPju3/+A8QOWe7DgoLvFMw9o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=BOG9jCZtLTEV1JYVIgoJM/YNsz3rT4WesEAhb5KBoF0JO1Z/5Eb7NZQDwNCzYBF0FSi1OgwSnCvO4UG/OfY6fuSbr/BXj7LUMGEdMaiOSmZe5RzDRkz8YdkAAas6R4SoU6oHoX8QiLlCg8qp//hjvXYGiN+/PwLZL7X4nz18lPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-86cc7cdb86fso34378239f.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 09 Jul 2025 12:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752089643; x=1752694443;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IiR6g+qyudooivd78b1N45PiW3XgKBWniwsSI4xqkII=;
        b=U+4xJTHKXWzUUtjtaDAzJC7H/asoYTl5pdflN84yOb3CC+Sr8/AKmC85y/r3ZeJ47/
         xnVSveVr1CV+XU21FyIFoEsav71IIEFLHVZhMRs3AMmPrLiU3VLxI9Mnuv+4KVYdIsDw
         1OEwGrp3hzCX3ptQoG4lJD/KP7S4tSY7SOtrhiaEvguh7Na3g7+9sSt5gYsn8ufjc29O
         QOb5PVq1fvW/AWtJlnxrJNo3TTpX0xmGr1CNaKTItnLWMjqTnamqkrEx7To5HU8TiGeJ
         CfyQTNdb5M7FH9E/Ek1Miq/OzkzemE1OLKDw6sio20GhIStiQoGN1K/0EfUoLD3ilcsg
         vF/A==
X-Forwarded-Encrypted: i=1; AJvYcCWF+D/Lrg3Nf7RZiGO5Ga1LUScW8NX9fgD/HxuU6FCqucIwo2u2gJxs3foEKEvywm4oAzxyWuGI+Rzt7/nqXg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7AGx93elQrb8Ux3+cEc0oknPodWaAFTlXIgpTBWRVuOXJtDmX
	AwdGsFxXGJdfVj7XwY+oZf/852I25MaCXPOBI/DoQ9OS6r1rOuWIRqNKfRV/bW4moUVQtXCDAAp
	I6FbdlSghX8L7V3o4lRc5THtrz4WlGGaPQLOa6GEKIL8fJTft0dwb7sZiJf8=
X-Google-Smtp-Source: AGHT+IEceed77DdA5JUd9P8OMerQksCR3D/DZggSl6GaOPAghZrlCXhOzd3qth9JjZ96NiSoTIVrQAHWpYA/ci/yPKvo49CWEAS+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:23c4:b0:3dd:f4d5:1c1a with SMTP id
 e9e14a558f8ab-3e1670d8889mr33353025ab.17.1752089643105; Wed, 09 Jul 2025
 12:34:03 -0700 (PDT)
Date: Wed, 09 Jul 2025 12:34:03 -0700
In-Reply-To: <686d2569.050a0220.1ffab7.000e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686ec42b.050a0220.385921.001e.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_copygc
From: syzbot <syzbot+3168625f36f4a539237e@syzkaller.appspotmail.com>
To: anna.luese@v-bien.de, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 82067c916994dd1bfec65496144dc16e17899e36
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri May 9 03:21:28 2025 +0000

    bcachefs: buckets_in_flight on stack

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10d6aa8c580000
start commit:   d006330be3f7 Merge tag 'sound-6.16-rc6' of git://git.kerne..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12d6aa8c580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14d6aa8c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd2783a0a99d4ed0
dashboard link: https://syzkaller.appspot.com/bug?extid=3168625f36f4a539237e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175fabd4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c0bf70580000

Reported-by: syzbot+3168625f36f4a539237e@syzkaller.appspotmail.com
Fixes: 82067c916994 ("bcachefs: buckets_in_flight on stack")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
