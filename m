Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEC71F94D
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 May 2024 19:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715455207; cv=none; b=lWvzpmSSlkijctpQ2fdr/1tB9sdH6xir+ZQEOwij/OqZMqvPzA4mDaDC3LqHprhRctMB4mAzW1kQu2cZOklPBFjLr9lu3qp8XL37dr6JQJKs5RP5IH19ENPvk46kawmFpHe6nTyVidrvXEGYy8FFm42z927jS97kmcxKfj1lN4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715455207; c=relaxed/simple;
	bh=+qv5reRo74cVbtPewf0lBZ2jqRG2ETEiX81GoJk+c40=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=EgTrGFCMw3QNHvCiD+ravj5mZBMrlMZFJBwzDl16fYFiC1iA4HIsmswe1PxIIkpi6bBz3D+9E7+To/40EeqtewjTZpvFI2cApIjHrN031lehXeUGU/vPCXYn5nz09NUN5mnMuvQGwjRYTQQR/HGsmdpmyqL6BF20zrG2ndd+Enk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7e17eba6ba3so280941239f.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 11 May 2024 12:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715455205; x=1716060005;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TU8kylx5Gi7UfPvHnXW2cq5h56a8jRhWapkflJkHeLA=;
        b=EfGMxYKNi36GIGLasrdcm7skumWxjIDrhscsuYwF8tlbN+lNxAAHi7N68Sx0DHOKKE
         hRz1HRxXLv/3kn82x6e/Oe68qHPlSVPwbwUQjXkslrdtxwnSsEHTs72ZMfJ3rPjbchNl
         am7dX0tgpE2SXEdqd2ZviONFFMKD/JV629si7SXujxaTHhpPqnnJK+Gs+5aE9vbxLoqZ
         9PI/vfT0GC3FyZWvmrEySN/dmnCS8zAQCOq5MP76qNeo0V91C5w2NfExpQRc1Kv19vp/
         eOrqC2Ac2QR6FVXkR+RivkjceIpPmEdpTNtbTQ2fApxaoHJRso+QAZ1gY/Tt1PId2pSJ
         8yRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+VwT10F4ri+T6vu6YbTlqtferPPUOww8G7q54kqOUyLk5zrkg4bQsTPuCBPmWzIjGxAkhgurzNE/cOpVWpcEK4VwDZ1jZ4YZOkk8Pa8Q=
X-Gm-Message-State: AOJu0YzPVm5JtbLYG6ByPMC1/bqKAUlccDCPcBTQgirkcDqtfN0OvgY4
	o7RFaBBt63JhFvtm6uXRT3TGH5RKluV4jg06hhfIPZzCp29P20ThRMKwebWWIk5LWeAdz3nNXX+
	rs0G6BRqk1oGJ2dFYXPjUCwm0OtgksDhNW/BPYI7v3upRgttpp6e5+3c=
X-Google-Smtp-Source: AGHT+IFQoLKTR0PomMsJmuoyW7oc8rG6EF2EtPkrDu6jPAscIBpu+Im9GhsGHH7rjpezK+/RJ84N2PgFrVl1yUwIXBxs170Q4cH4
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8305:b0:488:e81f:845d with SMTP id
 8926c6da1cb9f-48958e18e34mr397992173.4.1715455205110; Sat, 11 May 2024
 12:20:05 -0700 (PDT)
Date: Sat, 11 May 2024 12:20:05 -0700
In-Reply-To: <000000000000bc3c710617da7605@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002104c60618328a78@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_fs_usage_read_one
From: syzbot <syzbot+b68fa126ff948672f1fd@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=154e823f180000
start commit:   2b84edefcad1 Add linux-next specific files for 20240506
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=174e823f180000
console output: https://syzkaller.appspot.com/x/log.txt?x=134e823f180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b499929e4aaba1af
dashboard link: https://syzkaller.appspot.com/bug?extid=b68fa126ff948672f1fd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155c109f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=136e52b8980000

Reported-by: syzbot+b68fa126ff948672f1fd@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
