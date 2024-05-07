Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8695E1514F5
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 May 2024 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715081407; cv=none; b=TJRxkQxwR0JJWQBjzA/otsCO66zvb726LGneCNRqelpDxoqQAQE+lj1fTB2pSgQzjwlZCvvwRPqvWKSQ7/Qrri0cT1IYFP3VLmQFZHQpUSuswkct3j5OPnGIFKeGQR8QMIv7Oy9q0CQZ93mrlolqpOT2yjb1toCvN/i7nVvqeJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715081407; c=relaxed/simple;
	bh=ouPq1ImQr6BwL9gGhpva3sUJq8ov/1/P2vWzjlb0qCM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=AlDp9iAUIOEjN9FoFzuPbVu7VehzvOElQdBYUFEhTmfcv0nbS6eoRjDT6xu0ydO91eGiC4ky1iopyR194q2JL9ueiC2LGSzOJbfkhSnxJD4WE8CbNd2zP1hT2yL+vUd+qlIVHSlMgF+2fJ7IB6NW4EC11AD4aD4mU4sDcaJQmo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-36c7533ed44so24581245ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 07 May 2024 04:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715081405; x=1715686205;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4GUfzj+cOjI3lTKUNiWMDeoLyX1063O2jyJpXjnx1eU=;
        b=iJqZnUxaiZtK2blmggIk8B6uFHpcj3VLuBOnm/sABXTk0cHtuzIHmZVOI0ERK+pSah
         xsWluHgN4y7dMeRegUmjQdsO+t1TvCClcWVkkd+lXjjPZpnHH/BqTrgjz493RwuP3v5S
         9L20TjD4qwfvv1cNsJKZCjOMyqVVcDmyjQ1u5ph2UOUOCHjwqdkK8wpL0sM3hQzXZ+tS
         N3J40HpzVuF3X8XDMD230abEbVP/K+XDmpqcOmnZPWPoUWf3nrU1j8ww6PLDtmfAaY+0
         Hbxxf5sMzoGweHG4MCnVYI4zM0bEmnIFBjVQ+pnNnuCOBumbz/4QXETwl9EX6udHiA14
         dXag==
X-Forwarded-Encrypted: i=1; AJvYcCUxgvXvenG6QMYBNHMqFGcghR6Qj9Th8Z9R5qHvdokI8Du57Vap1VGlpuSjgFm4Kcn7dM56iB37fjm1Ow0XasVsIXcG+eR1Oh1d+QHiykw=
X-Gm-Message-State: AOJu0YzLuunXvcvdptBBQXib87vXYCHxfzUp0iQs85gymHQq6BpESLQv
	ZyuP4DwVmomYZSgLPJTddsj1bMWpEI9doLGgdXUhgp+m0vNfkCfGWcJ0hJLUxaxcNobWCGTPYwl
	vllH2cdcB/hAjyQJWC11/jx0ZIegUZ6moXgh5h/dkYfHW8hA9vy8j4Oc=
X-Google-Smtp-Source: AGHT+IEEu+uyAPb5jfl94XXMEfkVdZKh2KktG1jPdpJKDY6RdnOaOMt++iU0b26vxR+0bwAPkh+Xj0GoymWHrPs9skgHW8bkTELT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216e:b0:36c:4cc9:5923 with SMTP id
 s14-20020a056e02216e00b0036c4cc95923mr740783ilv.2.1715081405751; Tue, 07 May
 2024 04:30:05 -0700 (PDT)
Date: Tue, 07 May 2024 04:30:05 -0700
In-Reply-To: <00000000000067ff3c0617c603c2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f370b30617db817b@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in read_one_super
From: syzbot <syzbot+a8b0fb419355c91dda7f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=149d2fff180000
start commit:   dd5a440a31fa Linux 6.9-rc7
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=169d2fff180000
console output: https://syzkaller.appspot.com/x/log.txt?x=129d2fff180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d7ea7de0cb32587
dashboard link: https://syzkaller.appspot.com/bug?extid=a8b0fb419355c91dda7f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=135bf574980000

Reported-by: syzbot+a8b0fb419355c91dda7f@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
