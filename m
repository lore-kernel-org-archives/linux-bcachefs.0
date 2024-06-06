Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B2A198E61
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Jun 2024 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717697524; cv=none; b=N5ZqPg74tKMT1RDM/4udeFaHwWXiQY4qLEa95tA1lduDgfV9xbye4XVv61m1SYxZNILSEcEE/7wrEnX6Hfbd7tGaXIUTPctZntiF5NJ9bV9C66suf5Xc1T/N3Mf4OoLa5wOqzMudxO2GGGTLhsoL0bkYrR/UKknawdWCjBQIZhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717697524; c=relaxed/simple;
	bh=kLYzDmWA3pyQdK7Jqxoe6qobWlNGmt2GYRUgM8Acftk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=XTpCKegJZw/U/xCwDXEuJqyXBiQss7IkYYKPr5QKuN9xAUEHDPIz4/6mWqERXbwBWBS2CCI0qrsoD0jC+ELEPr298dbOonG6J+7C4dc/3K8w3aYsXVlJwkjYmJRsDYiKDi4AWMM7vsBpXQMW/wj0iBVUQ+FQ/5X0dp77cQip/P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7e1fe2ba2e1so138065039f.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Jun 2024 11:12:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717697522; x=1718302322;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V2rWMF7FdfmFH841KzQGtKomeowBbSw4OlbWNTnW3+w=;
        b=D+H3pFC5m4cL7xWuquByCfWZWtGd954iaF1XmRePtxV8E7jVKKaOc3qXkoANLLlXKK
         6l3/5Ods3BAtp0I25Ut0yUYXoiyHtAElZHAGl28BXpeYoq+OF+aNI5yR47vifhaNW/3G
         rRboY7ni6LiiTt3rZ0eIz5+nnU7t35Lc5v90jqN8abY6KV+sIrH4bwTDnkgHPUUI6+SD
         0brL1loClu8pRyW0GgJTi+cWl5PdBltAYAKbAoQ4qiFAxKyyyaC1QOcJVyxIEEOUpz43
         UhD3XLkmDclTDU2oRR3sxXDZQVTMfKpoHhfM8PdzbI9ydz51lSOcOG8Hu/QM/B37PjDc
         00Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUB8b6p/9qb74i94UX04zoK60RyeneZ159reoPzVuwWhAw22DcBB059yOJqUxHnNqMp6t530o92dyb4jqb59D7z6zGwMdMalZc5kOCXTDo=
X-Gm-Message-State: AOJu0YyDTBUg+OMTXNXbmYxHAo+cogSVWi9m82DHNoWoJaZIAD7m5QUn
	Cq3F0Z+/FHQLK3P314bqPfCQ9CpSv8Y5k4bEyq1JGcxI09damFVds2e6vAKI/EdlKBY1jk5Q4qB
	QstcGssQz/P2qkusRVmA44I+dtlOEuU4zauCuG//AGKMOsaEwsZiEgOM=
X-Google-Smtp-Source: AGHT+IFGDmcj0wx+kVc+721VYPwAJWApv5UjdfNQomzhQk27c2MwrVZ6VKmhSC0C4BXLfF0sU7CPtxrdwgX6u/8lRNfAOUrtmhtX
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c49:b0:374:a2db:d6b0 with SMTP id
 e9e14a558f8ab-375802fd4b9mr301405ab.2.1717697521927; Thu, 06 Jun 2024
 11:12:01 -0700 (PDT)
Date: Thu, 06 Jun 2024 11:12:01 -0700
In-Reply-To: <0000000000005221690619d26681@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a05a05061a3c9e19@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in gc_bucket
From: syzbot <syzbot+246b47da27f8e7e7d6fb@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 228e1c91ae5ec44f38aa8852aa3953005badce82
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Dec 27 23:31:46 2023 +0000

    bcachefs: KEY_TYPE_accounting

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16a17f16980000
start commit:   0e1980c40b6e Add linux-next specific files for 20240531
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15a17f16980000
console output: https://syzkaller.appspot.com/x/log.txt?x=11a17f16980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9c3ca4e54577b88
dashboard link: https://syzkaller.appspot.com/bug?extid=246b47da27f8e7e7d6fb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ca95fc980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a49ef2980000

Reported-by: syzbot+246b47da27f8e7e7d6fb@syzkaller.appspotmail.com
Fixes: 228e1c91ae5e ("bcachefs: KEY_TYPE_accounting")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
