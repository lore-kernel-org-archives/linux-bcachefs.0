Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82AF635
	for <linux-bcachefs@vger.kernel.org>; Sun,  2 Feb 2025 20:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738527965; cv=none; b=YoJUwjiaZ6NPkiFk+g0/YWL+TSw//ZMTkoUoRTVo+wClnKIa9g0VYQP0rjIlTLQGFpX18kDayhVVASWS4IDrL6qNknvQEZg5Wo1Jlje2/JM/S7j2nkNLQRva2G0/3oQQNAEfCT2r796RIVq/d6d9HGMX3jAUwgqRp3JXhVZdyWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738527965; c=relaxed/simple;
	bh=cgfQKzzVebYda0eg81+gYQMnQw4To32evYqLJndJ9/8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=XrUa1HNng/bBnpgzZrtvdO7PelXUL1p46SmdjbWheGbnVnZQFP0LHYfhrid6WpNpc40zcTNBO8giIUfYpQxZR3Jf2MV0Q31IZMu/OyGRvFskPADP7DrBHCGor6mbGkhtFPUZktwH1qQIUfVBx/NixgaWqaWkLDXofdWWXt6zwk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a9d4ea9e0cso29374585ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 02 Feb 2025 12:26:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738527963; x=1739132763;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K7FOQbTWGBoNbzXLLq7tZ06dNnV2c4bky+I3+pY2z5Y=;
        b=QfSB6BxblwjM4swz06JOTQ79Ufk5OJPtlWqYuxP9MV2AMLFY7wveIr5UzK/w/tDDwa
         OVDh5gYzaB6BcWL1HgbQ3xQoqrXTGqhbJP7ykasa/6bzPCr9cnn8szhBbQQPEDKFq5/s
         B1QTPwA2JiA47ElfNeuoxs535FpqPH7rtv2jXjZLJpfUU2ba2yur5JlMtc7xon5kTDW/
         Esye6Fdld+evCGR6OTb44LT/EqnODovtVj9yJ0dP1E4/rfh15weTnJrJRNmqF6usuZ+O
         D0WMM0kj+EJI5FUr+lF0RM6kp76a74c1qPfaisI4b+sYaB8xQSTIa8H54hvmzWASi2P1
         vi8w==
X-Forwarded-Encrypted: i=1; AJvYcCXymh82LqcFcYourtFuUe1bnXc/CvCajAwM/mxJqGDe+LnDC+GbnYQMAPayEHpq13Tn11K1ViO1RzDD4CdwCg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXHjfcS8WHVNu+GD2sKZ7Rp7xjSqNgy7kqNa9fr9Om9f39Bxoq
	9+AG5AcdcBQghrbMSm08UhciETLNA0KozaJu05ypLlM9KDsQo43xMjN+yLmQTW4aCZrJsTuJZIU
	/uXi0z1WoAzsuEaj5nLxjyfs5K8U3xyNFL14Uqveb/LaQMui9eqdYG1o=
X-Google-Smtp-Source: AGHT+IFhiVej29CuW61slUZEwlaLiFOwZB+mg8Zi5udIdcSg8B3Wih4OVkafY/2qzrvORwyGpGOnV0a77wiblDrM3l5NUXmxNbEj
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184a:b0:3d0:2a04:1cd9 with SMTP id
 e9e14a558f8ab-3d02a041d55mr36789525ab.21.1738527962841; Sun, 02 Feb 2025
 12:26:02 -0800 (PST)
Date: Sun, 02 Feb 2025 12:26:02 -0800
In-Reply-To: <674083af.050a0220.3c9d61.0190.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679fd4da.050a0220.d7c5a.0077.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in qlist_free_all
From: syzbot <syzbot+86b24455266617775c21@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, luto@kernel.org, mingo@redhat.com, 
	peterz@infradead.org, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 14152654805256d760315ec24e414363bfa19a06
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ec9724580000
start commit:   69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11ec9724580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16ec9724580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57ab43c279fa614d
dashboard link: https://syzkaller.appspot.com/bug?extid=86b24455266617775c21
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14034b24580000

Reported-by: syzbot+86b24455266617775c21@syzkaller.appspotmail.com
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
