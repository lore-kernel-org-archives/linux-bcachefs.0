Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 986825227;
	Sat, 21 Sep 2024 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726934550; cv=none; b=AUQnRSbN1A7Sy0hUQv4IXHuOHegX78L0JKGucArxeAKgybMyUi7PvX39AfTaiiug8NtzYIi8E2tXAkNS3oVi+I7na55fengTV1KhfR6DTBPzzOQ5bBXZNmRSuz3c1lr+zRuRmWkskO/Khzd0AGyu1X4+bAW3gBE0laTeZ3AL5x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726934550; c=relaxed/simple;
	bh=Bm8R3Wt+uUVdSVP2rFVOGIhwgPKqxsQ3yG9KOsmFdyc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=k0TCXdT9K8o/olK4z2m+L6+K1MZj83bo7y48C+Xo7vJSbbe+ctqWp1v6QwMAx6XT9lFtmSl15zNWn8aylJgutirIWqxZgU//4bewa28v7GONSHUNL+EIxZQiCryN+ll1xmtpX5Cy+9P3we48sznB6yrjZAIJs13qT4mFfJaQ4t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=fail (1024-bit key) header.d=163.com header.i=@163.com header.b=H2w2FOud reason="signature verification failed"; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=163.com header.i=@163.com header.b="H2w2FOud"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
	Message-ID; bh=J+IQdLfVB87ckETRJ35/zMdh9Xs/hl6oJzJ4fMVRUxc=; b=H
	2w2FOudzyxSL8mhg7CXkg9IByXFpBGK8clkPhd4kI+wJ5NPHRgRBnh0HbiZFzywH
	MlK5yasqJn+GYi3ddCzI/IkVCcdf9nMb1M4WFVK7J+sV+iXY8H39VKR7RfQ2ZsOS
	85XmwzixOZCGauzIu06frJVvuOb1KjpqZ50TfInDUY=
Received: from 00107082$163.com ( [111.35.191.143] ) by
 ajax-webmail-wmsvr-40-113 (Coremail) ; Sun, 22 Sep 2024 00:02:07 +0800
 (CST)
Date: Sun, 22 Sep 2024 00:02:07 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file
 has no overwrite.
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20240801(9da12a7b)
 Copyright (c) 2002-2024 www.mailtech.cn 163com
In-Reply-To: <ebqvaqme76nrgr2dh7avy7yjwxsgnnybxuybgxejahupgbrqw5@a6d244ghjqis>
References: <ka3sjrka6dugdaab2bvewfbonc3ksixumue3hs2juhajhjm37w@bnxvz5mozpgr>
 <20240907103437.71139-1-00107082@163.com>
 <ebqvaqme76nrgr2dh7avy7yjwxsgnnybxuybgxejahupgbrqw5@a6d244ghjqis>
X-NTES-SC: AL_Qu2ZBPWYu00p4SORZekXn0oTju85XMCzuv8j3YJeN500oiTR2woPbW9YDFLx+s6tJiehoAiUcjttxNhnRaJxYaID++1WZBUXEPtmXeuzf5YH
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <531cddb2.430d.1921551ada4.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cSgvCgD3v4sA7u5mzFcAAA--.4551W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbB0hFhqmWX0jhMngADsB
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

SGksIAoKQXQgMjAyNC0wOS0wOSAyMTozNzozNSwgIktlbnQgT3ZlcnN0cmVldCIgPGtlbnQub3Zl
cnN0cmVldEBsaW51eC5kZXY+IHdyb3RlOgo+T24gU2F0LCBTZXAgMDcsIDIwMjQgYXQgMDY6MzQ6
MzdQTSBHTVQsIERhdmlkIFdhbmcgd3JvdGU6Cgo+Cj5CaWcgc3RhbmRhcmQgZGV2aWF0aW9uICho
aWdoIHRhaWwgbGF0ZW5jeT8pIGlzIHNvbWV0aGluZyB3ZSdkIHdhbnQgdG8KPnRyYWNrIGRvd24u
IFRoZXJlJ3MgYSBidW5jaCBvZiB0aW1lX3N0YXRzIGluIHN5c2ZzLCBidXQgdGhleSdyZSBtb3N0
bHkKPmZvciB0aGUgd3JpdGUgcGF0aHMuIElmIHlvdSdyZSB0cnlpbmcgdG8gaWRlbnRpZnkgd2hl
cmUgdGhlIGxhdGVuY2llcwo+YXJlIGNvbWluZyBmcm9tLCB3ZSBjYW4gbG9vayBhdCBhZGRpbmcg
c29tZSBuZXcgdGltZSBzdGF0cyB0byBpc29sYXRlLgoKQWJvdXQgcGVyZm9ybWFuY2UsIEkgaGF2
ZSBhIHRoZW9yeSBiYXNlZCBvbiBzb21lIG9ic2VydmF0aW9uIEkgbWFkZSByZWNlbnRseToKV2hl
biB1c2VyIHNwYWNlIGFwcCBtYWtlIGEgNGsoOCBzZWN0b3JzKSBkaXJlY3Qgd3JpdGUsIApiY2Fj
aGVmcyB3b3VsZCBpbml0aWF0ZSBhIHdyaXRlIHJlcXVlc3Qgb2YgfjExIHNlY3RvcnMsIGluY2x1
ZGluZyB0aGUgY2hlY2tzdW0gZGF0YSwgcmlnaHQ/ClRoaXMgbWF5IG5vdCBiZSBhIGdvb2Qgb2Zm
c2V0K3NpemUgcGF0dGVybiBvZiBibG9jayBsYXllciBmb3IgcGVyZm9ybWFuY2UuICAKKEkgZGlk
IGdldCBhIHZlcnktdmVyeSBiYWQgcGVyZm9ybWFuY2Ugb24gZXh0NCBpZiB3cml0ZSB3aXRoIDVL
IHNpemUuKQoKU28gSSB0aGluaywgd291bGQgaXQgYmUgZmVhc2libGUgdG8gbWFrZSBjaGVja3N1
bSBzZWN0b3JzIG9uIGEgNC84IHNlY3RvciBib3VuZGFyeT8KVGhpcyB3aWxsIHdhc3RlIG1vcmUg
ZGlza3NwYWNlLCBidXQgbWF5IG1ha2UgYmxvY2sgbGF5ZXIgaGFwcHk/CgoKVGhhbmtzCkRhdmlk
ICAK
