Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD9E52907;
	Tue, 24 Sep 2024 12:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727181534; cv=none; b=QLj0xmQgNueZiFH3poravN64GBsTlEDfEet8j8J8x1YsEEFjEeu94KRRGx/AZ8l5hzbSpgCYVCUiR01Ju0se5jGfw1QtATTWPNJDEtwp0OebAjsIqMdLoYfr2SsWwMoFz+V5dO4KIP7BTEDsvU3l7i5oUoA+7lSAbQ/8D0q89gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727181534; c=relaxed/simple;
	bh=faa6imd7lE6BcMFqO48/o3cyjsA9elv/WkwLO0G3rGU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=mrSe+elOZZOeUAdOsz/PULrqPBsUFHCWtBgblFdxApNPIozZgJ8C4PxO+86q7QwOfHxDYvmlZfql+N8FXZxqqF1NmQBxqpEbvOHMJ4owFOk+ZqUedVqWe7UPkRWU28x/Q9xbSTkzp9quJV3ZkTPn0Bj6dwVQbGUUUHzRf4zigao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=fail (1024-bit key) header.d=163.com header.i=@163.com header.b=Qf2HxapK reason="signature verification failed"; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=163.com header.i=@163.com header.b="Qf2HxapK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
	Message-ID; bh=DIfNVk5CauZ6NK2yNcaBXApRTZBwvdPRcS24YcB8ZlY=; b=Q
	f2HxapKSw5RvNjGLAWQ0IhQg+k4PxwUsoPF/Ck9rzaw0AG7QNzNp0ubx2T75v/NN
	4BZ3k9QEndoMaw+UVBwzQTxFdixZNyrn6BPKHaVPMKvAqC0SFH1QlBeQF6Rv7Yuu
	a8nwnwdCz0F0J1ubG7So/S8j5LoQY1/o1GzWn5BF9Y=
Received: from 00107082$163.com ( [111.35.191.143] ) by
 ajax-webmail-wmsvr-40-136 (Coremail) ; Tue, 24 Sep 2024 20:38:29 +0800
 (CST)
Date: Tue, 24 Sep 2024 20:38:29 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file
 has no overwrite.
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20240801(9da12a7b)
 Copyright (c) 2002-2024 www.mailtech.cn 163com
In-Reply-To: <q4jjkhgpahmrr3z7d5qn7qhml3kqtj3roybuykkhfefxlezdbf@y4lbf6ut4siw>
References: <20240907103437.71139-1-00107082@163.com>
 <20240924110807.28788-1-00107082@163.com>
 <q4jjkhgpahmrr3z7d5qn7qhml3kqtj3roybuykkhfefxlezdbf@y4lbf6ut4siw>
X-NTES-SC: AL_Qu2ZBf2Tvk0r7ymbZekXn0oTju85XMCzuv8j3YJeN500sSbm9woBcnBPI0rd4sO3LQmSvxeHTDFj9MBTbZFxdKRiQxhXPHdX4AuZULBqA4TO
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <6aecd8b7.bb5e.192240a5533.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:iCgvCgD333HGsvJm_QwAAA--.716W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiMwRkqmbyorkFCAAFs+
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CgpBdCAyMDI0LTA5LTI0IDE5OjMwOjQ0LCAiS2VudCBPdmVyc3RyZWV0IiA8a2VudC5vdmVyc3Ry
ZWV0QGxpbnV4LmRldj4gd3JvdGU6Cj5PbiBUdWUsIFNlcCAyNCwgMjAyNCBhdCAwNzowODowN1BN
IEdNVCwgRGF2aWQgV2FuZyB3cm90ZToKPj4gSGksIAo+PiAKPj4gQXQgMjAyNC0wOS0wNyAxODoz
NDozNywgIkRhdmlkIFdhbmciIDwwMDEwNzA4MkAxNjMuY29tPiB3cm90ZToKPj4gPkF0IDIwMjQt
MDktMDcgMDE6Mzg6MTEsICJLZW50IE92ZXJzdHJlZXQiIDxrZW50Lm92ZXJzdHJlZXRAbGludXgu
ZGV2PiB3cm90ZToKPj4gPj5UaGF0J3MgYmVjYXVzZSBjaGVja3N1bXMgYXJlIGF0IGV4dGVudCBn
cmFudWxhcml0eSwgbm90IGJsb2NrOiBpZiB5b3UncmUKPj4gPj5kb2luZyBPX0RJUkVDVCByZWFk
cyB0aGF0IGFyZSBzbWFsbGVyIHRoYW4gdGhlIHdyaXRlcyB0aGUgZGF0YSB3YXMKPj4gPj53cml0
dGVuIHdpdGgsIHBlcmZvcm1hbmNlIHdpbGwgYmUgYmFkIGJlY2F1c2Ugd2UgaGF2ZSB0byByZWFk
IHRoZSBlbnRpcmUKPj4gPj5leHRlbnQgdG8gdmVyaWZ5IHRoZSBjaGVja3N1bS4KPj4gPgo+PiA+
Cj4+IAo+PiA+QmFzZWQgb24gdGhlIHJlc3VsdDoKPj4gPjEuIFRoZSByb3cgd2l0aCBwcmVwYXJl
LXdyaXRlIHNpemUgNEsgc3RhbmRzIG91dCwgaGVyZS4KPj4gPldoZW4gZmlsZXMgd2VyZSBwcmVw
YWlyZWQgd2l0aCB3cml0ZSBzaXplIDRLLCB0aGUgYWZ0ZXJ3YXJkcwo+PiA+IHJlYWQgcGVyZm9y
bWFuY2UgaXMgd29yc2UuICAoSSBkaWQgZG91YmxlIGNoZWNrIHRoZSByZXN1bHQsCj4+ID5idXQg
aXQgaXMgcG9zc2libGUgdGhhdCBJIG1pc3Mgc29tZSBhZmZlY3RpbmcgZmFjdG9ycy4pOwo+PiA+
Mi4gV2l0aG91dCBPX0RJUkVDVCwgcmVhZCBwZXJmb3JtYW5jZSBzZWVtcyBjb3JyZWxhdGVkIHdp
dGggdGhlIGRpZmZlcmVuY2UKPj4gPiBiZXR3ZWVuIHJlYWQgc2l6ZSBhbmQgcHJlcGFyZSB3cml0
ZSBzaXplLCBidXQgd2l0aCBPX0RJUkVDVCwgY29ycmVsYXRpb24gaXMgbm90IG9idmlvdXMuCj4+
ID4KPj4gPkFuZCwgdG8gbWVudGlvbiBpdCBhZ2FpbiwgaWYgSSBvdmVyd3JpdGUgdGhlIGZpbGVz
ICoqdGhvcm91Z2hseSoqIHdpdGggZmlvIHdyaXRlIHRlc3QKPj4gPih1c2luZyBzYW1lIHNpemUp
LCB0aGUgcmVhZCBwZXJmb3JtYW5jZSBhZnRlcndhcmRzIHdvdWxkIGJlIHZlcnkgZ29vZDoKPj4g
Pgo+PiAKPj4gVXBkYXRlIHNvbWUgSU8gcGF0dGVybiAoYmlvIHN0YXJ0IGFkZHJlc3MgYW5kIHNp
emUsIGluIHNlY3RvcnMsIGFkZHJlc3MmPS1hZGRyZXNzKSwKPj4gYmV0d2VlbiBiY2FjaGVmcyBh
bmQgYmxvY2sgbGF5ZXI6Cj4+IAo+PiA0Sy1EaXJlY3QtUmVhZCBhIGZpbGUgY3JlYXRlZCBieSBs
b29wIG9mIGB3cml0ZShmZCwgYnVmLCAxMDI0KjQpYDoKPgo+WW91J3JlIHN0aWxsIHRlc3Rpbmcg
c21hbGwgcmVhZHMgdG8gYmlnIGV4dGVudHMuIEZsaXAgb2ZmIGRhdGEKPmNoZWNrc3VtbWluZyBp
ZiB5b3Ugd2FudCB0byB0ZXN0IHRoYXQsIG9yIHdhaXQgZm9yIGJsb2NrIGdyYW51bGFyCj5jaGVj
a3N1bXMgdG8gbGFuZC4KPgo+SSBhbHJlYWR5IGV4cGxhaW5lZCB3aGF0J3MgZ29pbmcgb24sIHNv
IHRoaXMgaXNuJ3QgdmVyeSBoZWxwZnVsLgoKSGksIAoKSSBkbyB1bmRlcnN0YW5kIGl0IG5vdywg
c29ycnkgZm9yIGJvdGhlcmluZy4KTW9zdGx5IEkgd2FudGVkIHRvIGV4cGxhaW4gdG8gbXlzZWxm
IHdoeSB0aGUgZGlmZmVyZW5jZS4uLi4gCgpCZXNpZGUgdGhhdCwganVzdCB3YW50IHRvIG1lbnRp
b24gdGhlcmUgaXMgc29tZSBpbyBzaXplIG9mICcxIHNlY3RvcicsIGZlZWwgc3RyYW5nZSBhYm91
dCBpdC4uLgoKCkRhdmlkCg==
