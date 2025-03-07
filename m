Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1734222173C
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 22:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387324; cv=none; b=orl0zCEh3HNp7L05rVetXIP3JVI3vJsT06XRcjIUfxc7S/Winfbuwbt9mS9JcTbTI57nVp5FDX7ddUjatEYhtWFh7gd3Xft2uLG7u8YqMJSgu/ZdDVQfbYauj67klNMVPKyt3lzMShdhCpqTu6GoNSitfIi9JZAoeOsTkknn8PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387324; c=relaxed/simple;
	bh=FIE09kMTKcjOb6IpPw4BV0dkrJbXktb7sivz1hHqVoc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=s3U4D/4cg4tJtIBDBbDkUcBZT0anp0nrh4CV1H2WTVolVMqjpvYartqNiU+74VREXAkg1wkXaDtkvUE0zmTVLQRsGQ6z2MRWmoK6PDKRrAt0s+oKEEuM2aTJsjSmjnBehx6N/gz0daz6yj6R45h68gXTEy75tVHyASYbM8sOcW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-85ae0f7ce5fso179077839f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Mar 2025 14:42:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741387322; x=1741992122;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Cha8nI3yHP4ekbqsmtiYifVX6bODFDBdxD8YqobpxI=;
        b=H5UvWXqVFNNclBvJOQWnO+9CE7LWzHUkdP00PbLEStZy1HDg3xm/hsXIXSRcsMyP9X
         cCjUn+8bOQXY7svCtwVta059O+ST/06XznM43zB0XuM2FcxtO+eHkBwcVF0waD1FBPNX
         +Mn5r2Q7z5LYjZ4fzcssjqEB0uYZFwz5h5/BfIt/AZzhiXAVM3DVqaXd1bY1Zrfd/xTj
         3kqX/5/btGZIB6VCYf/SGEnWb9xullwYoAGHrLat5blkZtAJtvQPlNZRFeSEBLEuujzw
         ibOsZYmyJ8CqlGTMEvWY2c9eIaXS5JWqGHE6iK0hnpJo2DDyIROyhJkpt1NlI55zu+IB
         +gHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBv1TAD032emop2+npB2hs7IodK2tVTk5BsLyK8VcRNm5gVTuIZVs+RcuBWm1fcPHXiebiKuXYFXXvL/wMlQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiLAXout2EwcQtS+E+ib8TvX/Zc1+UYwA7al3QNFUYDaB5T5p3
	wDKe18bTIyQodhueoQpF98PaSdIoOJUteBe0YuouAh45CiWrYrn/5MEN4JVP6V+jueVi6XIKofi
	Q1N4W6uIX/GscHdNLzxiVuGlQtUdYt/8WG4HOeVam3daGIyVpBiSeI3c=
X-Google-Smtp-Source: AGHT+IHyFZ5xCG7t++nhjLckAX5gJDHtCBeqTd5EYA9ucH+LjWpniikL2yxT2tKfXWWeuxxwxr6C24DgnBiZLBKHtcYesS7J6gZl
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174b:b0:3d4:2a4e:1272 with SMTP id
 e9e14a558f8ab-3d441a46c62mr66847485ab.19.1741387322248; Fri, 07 Mar 2025
 14:42:02 -0800 (PST)
Date: Fri, 07 Mar 2025 14:42:02 -0800
In-Reply-To: <67a4eae3.050a0220.65602.0001.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67cb763a.050a0220.d8275.0226.GAE@google.com>
Subject: Re: [syzbot] [mm?] [bcachefs?] KASAN: slab-use-after-free Read in list_lru_del
From: syzbot <syzbot+6663075ddb9be85fa6e5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 14152654805256d760315ec24e414363bfa19a06
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=108d43a8580000
start commit:   03d38806a902 Merge tag 'thermal-6.14-rc5' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=128d43a8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=148d43a8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8de9cc84d5960254
dashboard link: https://syzkaller.appspot.com/bug?extid=6663075ddb9be85fa6e5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104d2864580000

Reported-by: syzbot+6663075ddb9be85fa6e5@syzkaller.appspotmail.com
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
