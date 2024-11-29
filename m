Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C502C18C
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 22:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732919926; cv=none; b=QvTG6EW2X/BpGIe+FKYkGbLtT/3sVroWH+8rZhEIGWiEvJE7E8s2mGcbBxL0Yatf3wPLCqYv96MY6oLS2WC19wjzG1W0aMUf0nQyBU2qTflja4Mk/oDbetRCx+6hV045YzYMKT6E3+5MofQMACU/nFuR6PHbSb7zQZtBfNOFmoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732919926; c=relaxed/simple;
	bh=82EnS5fxs4HAEKp3RYPaUrmzu5xS+BPxemHrEA4kBsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VX9DSVEz2yiRB7QotIaO9p/zBOjJ5/Rsz4UlVtsxmJVPRf92gri+78BQernby5lksXTMhMVBr2UR0XtOIuBuKrpc4i5WULPSjDATTA40gnnlFH0uwm4e9ECO1deh/PS1PGEUVve9sbDgiCVRmCIKGTKQTZU9z2AxAloa1j+ARus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eDMwiYTE; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eDMwiYTE"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7f8b37edeb7so1576982a12.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 14:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732919921; x=1733524721; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O20YdsRWSCZeo0YE58LeV4jhBG07ObRjvq/lCHiTEP0=;
        b=eDMwiYTEnXvlkittI9npbEaFEECSQZOYGhDjHh+rpyXHifFsHzm6KjH06YnhlI1sGi
         a9R9o2j8449JFUSa2zxFqUZxxoXR29QRuZZ5Au+6s/5LYApWA7uo62Sghv4WxaFvtUnj
         F/OurE+WeRM5P1LWaQMTFhX0/yB4fM3Xy68q30m70jUBIThoayCBajp6MKAv/RZYmOkt
         HX8VvBW6eV0HC8puobxDBAnRX6TlcCqAd0Egj65TcWYTeqzpgLW6mKwz9jrrBjtG47rW
         N0CSTco3Zt+WrNTQcQd36PZ7SmGuZMp4A61435e4Hq7e3NIwuN9VzONA6dZpzqUx4Bj5
         Qp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732919921; x=1733524721;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O20YdsRWSCZeo0YE58LeV4jhBG07ObRjvq/lCHiTEP0=;
        b=IVq/cEknusJPjczGHORnKye5NqT3FgZ2S4UasJqikrO4QC2ehQ2XoP/yXrDRiwuIxY
         sktGVYVlWUnbMFiWgaJbeXoRNw9eJh8fN2ZIySjHGDRXwDw7CP/VzYgjKP9MTwM8xNzX
         RTRWfvxXvbklyywc7U3f9yf5+ttyADDc74nP4/1E66IcY1hpXWA2NWhwZARRk0YI9P/k
         W1X00ZXK0SKBxE5fjID52YfimcZksG/nVDjlIXT5fFPWc/Po3kB9oHZmewOkoBdFr5Y1
         yA0XGKD4BVnWgdwp667HfhoI851x/cN8PIi3K6DoK797DteHIrj6uqi7ZXv0J2L9VgGH
         nyUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM/pD0slK8gAnbVCUb4Mf9dYESnPaaDF0YxmLPj9FFyKFp5qLU9kuEnQCES/XlipFJycxb0yEorrJ/lC+scg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx77xHYgDSoFq9HH1qda5ucRSvnYBGlNgOkBohAU/NUZDuIwE/
	4Bv+ZNnsR5oXQleI4XQBmoDJv0e6F6lYsp48EdxwHaSeFin0SYve4JFndYwBhuw=
X-Gm-Gg: ASbGnctvyYIOa7JB5odyXHI76lvR0sNljs/sLkt5oy/UXj8CaXXOuur4464sZwEiUXR
	KG0TnusYa9Y/VOy+FQNyZFVYE6r79xVQlP5W7xULL+4K3C0dDkr0yfNuioGxSZrn93AYTpCSV8V
	zqhj4uTHRQ70okD+zZUUQrZu/Pq+Rwm4bS0gGPTcwWIa48NBjg3Z6a5bavxqU11dOuEBt39Kwy8
	/hMA4Cu6XLzhaHhHGQmAd3G9HYTgXzXH4DcHfvbgC5QYys=
X-Google-Smtp-Source: AGHT+IHQ/VIOEnW3xZjBxTkbDwYUQgW6Fls1BLgVH0Y+gVaXlY1j5GJ0z4qFDjmBShxPGgn0gkc5Gg==
X-Received: by 2002:a05:6a20:729b:b0:1db:d980:440e with SMTP id adf61e73a8af0-1e0e0afa6a5mr19837624637.14.1732919921048;
        Fri, 29 Nov 2024 14:38:41 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7254f689085sm1978952b3a.131.2024.11.29.14.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 14:38:40 -0800 (PST)
Message-ID: <7c326933-8d23-4c98-81fa-a9bb467d69c5@kernel.dk>
Date: Fri, 29 Nov 2024 15:38:39 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/34] bcachefs: dio write: Take ref on mm_struct when
 using asynchronously
To: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Cc: Jann Horn <jannh@google.com>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
 <20241129202736.2713679-21-kent.overstreet@linux.dev>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241129202736.2713679-21-kent.overstreet@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Looks good to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe
