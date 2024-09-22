Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DFCC176AC3;
	Sun, 22 Sep 2024 08:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726994877; cv=none; b=ttSjG220Q+gjE5jFQ/CMa2zHn/ADVKsJv3HJ93g7yJ8wd0JZaC1gBxSJuDC2dO9gg0k3db+aLAssNWdNW9ulnas93CfN8LtxZWvY1Qz4NcABmTOyRdWfwIUWgOul4LN+ChWL9m9umz20NBig/qOPFElPVq1O5qD3yGlaZHxBRsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726994877; c=relaxed/simple;
	bh=A9QRinL2AqDGsnSuFzchYLYIA5QIF5TFYfI4vFEGbG8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=UGk+gLlOcHLUmZuuxvOwJCP8kn9TKrnQRP0O5UvRfoYX5eGyZ0Sq0VuEMr8v956aZHdcUmhrSosALskWBMf84rFL9hbpZ1X4MyxQTsSo5v3/B2zrwlorzjvjpgQG0KQS2EfdzP7w4/bxoQ3Q90RgqOUvvA4zH9t2TlM0A13kFrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=fail (1024-bit key) header.d=163.com header.i=@163.com header.b=XmVPvsdp reason="signature verification failed"; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=163.com header.i=@163.com header.b="XmVPvsdp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
	Message-ID; bh=lg0wJWyar9THY53fKkciHpwQH2L/jJMZlVEM8o1rz1s=; b=X
	mVPvsdp6k9NERp0+PK9YwrBNw+bldEgPU750LM8G/LXiWn04lTIFwhfAjdqduaPZ
	LIJZv6MZw9bErYw0UIsZ1+KL00t/CPVERbA2x7p/SPnJO2rYgVC2FrBNUhbJmex/
	DHQwxOkWvUCqTvAOny7Ms3wFNmNOxNulKDHNQBjlXY=
Received: from 00107082$163.com ( [111.35.191.143] ) by
 ajax-webmail-wmsvr-40-140 (Coremail) ; Sun, 22 Sep 2024 16:47:25 +0800
 (CST)
Date: Sun, 22 Sep 2024 16:47:25 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file
 has no overwrite
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20240801(9da12a7b)
 Copyright (c) 2002-2024 www.mailtech.cn 163com
In-Reply-To: <20240922083148.10070-1-00107082@163.com>
References: <79f17c7a.65f.19217621c47.Coremail.00107082@163.com>
 <20240922083148.10070-1-00107082@163.com>
X-NTES-SC: AL_Qu2ZBPWSu0Av4yeYZ+kXn0oTju85XMCzuv8j3YJeN500hyX/8xgmcnBuOXvk4sOPLhGSvxe4fyJl+MlZT4xGdLLpf0YaJlFpAJf5Y3zAafAL
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <3fcdf5b3.203d.19218ea100b.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:jCgvCgD3n02e2e9m+90CAA--.27548W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiMxpiqmbvz7duQQABs+
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkF0IDIwMjQtMDktMjIgMTY6MzE6NDgsICJEYXZpZCBXYW5nIiA8MDAxMDcwODJAMTYzLmNvbT4g
d3JvdGU6Cj4+SGksIAo+PgoKPmJ0cmVlX2lvIHdyaXRlIHBhdHRlcm4sIGNvbGxlY3RlZCBmcm9t
IGJ0cmVlX25vZGVfd3JpdGVfZW5kaW8sIAo+aXMga2luZCBvZiB1bmlmb3JtL2ZsYXQgZGlzdHJp
YnV0ZWQsIG5vdCBvbiBibG9jay1mcmllbmRseSBzaXplCj5ib3VuZGFyaWVzIChJIHRoaW5rKToK
PgkrLS0tLS0tLS0tKy0tLS0tLS0tLS0tLSsKPgl8IHNlY3RvcnMgfCBwZXJjZW50YWdlIHwKPgkr
LS0tLS0tLS0tKy0tLS0tLS0tLS0tLSsKPgl8ICAgIDEgICAgfCAgIDkuMDIxJSAgIHwKPgl8ICAg
IDMgICAgfCAgIDEuNDQwJSAgIHwKPgl8ICAgIDQgICAgfCAgIDEuMjQ5JSAgIHwKPgl8ICAgIDIg
ICAgfCAgIDEuMTU3JSAgIHwKPgl8ICAgIDUgICAgfCAgIDAuODA0JSAgIHwKPgl8ICAgIDYgICAg
fCAgIDAuNDA5JSAgIHwKPgl8ICAgIDE0ICAgfCAgIDAuMjU5JSAgIHwKPgl8ICAgIDE1ICAgfCAg
IDAuMjUzJSAgIHwKPgl8ICAgIDE2ICAgfCAgIDAuMjI4JSAgIHwKPgl8ICAgIDcgICAgfCAgIDAu
MjI2JSAgIHwKPgl8ICAgIDExICAgfCAgIDAuMjIzJSAgIHwKPgl8ICAgIDEwICAgfCAgIDAuMjIz
JSAgIHwKPgl8ICAgIDEzICAgfCAgIDAuMjIyJSAgIHwKPgl8ICAgIDkgICAgfCAgIDAuMjEzJSAg
IHwKPgl8ICAgIDEyICAgfCAgIDAuMjAyJSAgIHwKPgl8ICAgIDQxICAgfCAgIDAuMTk0JSAgIHwK
Pgl8ICAgIDE3ICAgfCAgIDAuMTgzJSAgIHwKPgl8ICAgIDggICAgfCAgIDAuMTgyJSAgIHwKPgl8
ICAgIDE4ICAgfCAgIDAuMTY3JSAgIHwKPgl8ICAgIDIwICAgfCAgIDAuMTY3JSAgIHwKPgl8ICAg
IDE5ICAgfCAgIDAuMTYzJSAgIHwKPgl8ICAgIDIxICAgfCAgIDAuMTYwJSAgIHwKPgl8ICAgMjA1
ICAgfCAgIDAuMTU4JSAgIHwKPgl8ICAgIDIyICAgfCAgIDAuMTQ1JSAgIHwKPgl8ICAgIDIzICAg
fCAgIDAuMTE3JSAgIHwKPgl8ICAgIDI0ICAgfCAgIDAuMDkzJSAgIHwKPgl8ICAgIDUxICAgfCAg
IDAuMDg5JSAgIHwKPgl8ICAgIDI1ICAgfCAgIDAuMDgwJSAgIHwKPgl8ICAgMjA0ICAgfCAgIDAu
MDc5JSAgIHwKPgkrLS0tLS0tLS0tKy0tLS0tLS0tLS0tLSsKPgoKT29wcy4uLndyb25nIHdlaWdo
dCB1c2VkIHRvIGNhbGN1bGF0ZSBwZXJjZW50YWdlLCBpdCBzaG91bGQgYmUKKy0tLS0tLS0tLSst
LS0tLS0tLS0tLS0rCnwgc2VjdG9ycyB8IHBlcmNlbnRhZ2UgfAorLS0tLS0tLS0tKy0tLS0tLS0t
LS0tLSsKfCAgICAxICAgIHwgIDQ1LjEwNSUgICB8CnwgICAgMyAgICB8ICAgNy4yMDAlICAgfAp8
ICAgIDQgICAgfCAgIDYuMjQ0JSAgIHwKfCAgICAyICAgIHwgICA1Ljc4NSUgICB8CnwgICAgNSAg
ICB8ICAgNC4wMTglICAgfAp8ICAgIDYgICAgfCAgIDIuMDQ1JSAgIHwKfCAgICAxNCAgIHwgICAx
LjI5NiUgICB8CnwgICAgMTUgICB8ICAgMS4yNjQlICAgfAp8ICAgIDE2ICAgfCAgIDEuMTQxJSAg
IHwKfCAgICA3ICAgIHwgICAxLjEyOSUgICB8CnwgICAgMTEgICB8ICAgMS4xMTclICAgfAp8ICAg
IDEwICAgfCAgIDEuMTEzJSAgIHwKfCAgICAxMyAgIHwgICAxLjExMSUgICB8CnwgICAgOSAgICB8
ICAgMS4wNjUlICAgfAp8ICAgIDEyICAgfCAgIDEuMDExJSAgIHwKfCAgICA0MSAgIHwgICAwLjk3
MSUgICB8CnwgICAgMTcgICB8ICAgMC45MTMlICAgfAp8ICAgIDggICAgfCAgIDAuOTEyJSAgIHwK
fCAgICAxOCAgIHwgICAwLjgzNiUgICB8CnwgICAgMjAgICB8ICAgMC44MzUlICAgfAp8ICAgIDE5
ICAgfCAgIDAuODEyJSAgIHwKfCAgICAyMSAgIHwgICAwLjc5OSUgICB8CnwgICAyMDUgICB8ICAg
MC43OTElICAgfAp8ICAgIDIyICAgfCAgIDAuNzI0JSAgIHwKfCAgICAyMyAgIHwgICAwLjU4NyUg
ICB8CnwgICAgMjQgICB8ICAgMC40NjUlICAgfAp8ICAgIDUxICAgfCAgIDAuNDQzJSAgIHwKfCAg
ICAyNSAgIHwgICAwLjM5OCUgICB8CnwgICAyMDQgICB8ICAgMC4zOTYlICAgfAorLS0tLS0tLS0t
Ky0tLS0tLS0tLS0tLSsKCgpEYXZpZAo=
